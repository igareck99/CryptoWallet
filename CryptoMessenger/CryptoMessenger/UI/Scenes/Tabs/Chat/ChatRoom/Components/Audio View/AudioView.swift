import SwiftUI
import AVFoundation

// MARK: - AudioView

struct AudioView: View {

    // MARK: - Private Properties

	@StateObject private var audioViewModel: AudioMessageViewModel
	@Binding private var activateShowCard: Bool
	@Binding private var playingAudioId: String

	private let shortDate: String
	private let messageId: String
	private let isCurrentUser: Bool
	private let isFromCurrentUser: Bool
	private let audioDuration: String
	private let reactionItems: [ReactionTextsItem]
	@State private var totalHeight: CGFloat = .zero

    // MARK: - Lifecycle

	init(
		messageId: String,
		shortDate: String,
		audioDuration: String,
		isCurrentUser: Bool,
		isFromCurrentUser: Bool,
		reactionItems: [ReactionTextsItem],
		activateShowCard: Binding<Bool>,
		playingAudioId: Binding<String>,
		audioViewModel: StateObject<AudioMessageViewModel>
	) {
		self.messageId = messageId
		self.shortDate = shortDate
		self.audioDuration = audioDuration
		self.isCurrentUser = isCurrentUser
		self.isFromCurrentUser = isFromCurrentUser
		self.reactionItems = reactionItems
		self._activateShowCard = activateShowCard
		self._playingAudioId = playingAudioId
		self._audioViewModel = audioViewModel
	}

    // MARK: - Body

    var body: some View {
		ZStack {
			VStack(alignment: .leading, spacing: 0) {
				HStack(alignment: .center, spacing: 12) {
					Button(action: audioViewModel.play) {
						ZStack {
							Circle().frame(width: 48, height: 48)
								.background { Color.lapisLazuli }
								.cornerRadius(24)
							!audioViewModel.isPlaying ?
							R.image.chat.audio.audioPlay.image :
							R.image.chat.audio.audioStop.image
						}
					}
					.padding(.vertical, 8)
					.padding(.leading, isCurrentUser ? 8 : 16)
					VStack(alignment: .leading, spacing: 10) {
						SliderAudioView(
							value: Binding(get: { audioViewModel.time }, set: { newValue in
								audioViewModel.time = newValue
								audioViewModel.audioPlayer?.currentTime =
								Double(audioViewModel.time) * (audioViewModel.audioPlayer?.duration ?? 0)
								audioViewModel.audioPlayer?.play()
							}),
							activateShowCard: $activateShowCard
						)
						.padding(.trailing, 8)
						.frame(height: 1)
						Text(audioDuration)
							.font(.regular(12))
							.foreground(.darkGray())
					}
					.padding(.top, 20)
					.padding(.trailing, 7)
				}

				ReactionsGrid(
					totalHeight: $totalHeight,
                    viewModel: ReactionsGroupViewModel(items: reactionItems)
				)
				.frame(
                    minHeight: totalHeight == 0 ? viewHeightNew(for: 252, reactionItems: reactionItems) : totalHeight
				)
				.padding([.leading, .trailing], 8)
				.padding(.bottom, 4)
			}
			.padding(.bottom, 16)
			.frame(width: 252)
			VStack(alignment: .leading, spacing: 0) {
				CheckTextReadView(
					time: shortDate,
					isFromCurrentUser: isFromCurrentUser
				)
                .padding(.leading, !isFromCurrentUser ? 195 : 0)
			}
		}
		.onReceive(audioViewModel.timer, perform: { _ in
			audioViewModel.onTimerChange()
		})
		.onChange(of: activateShowCard, perform: { _ in
			audioViewModel.stop()
		})
		.onChange(of: audioViewModel.playingAudioId, perform: { value in
			$playingAudioId.wrappedValue = value
		})
		.onAppear {
			audioViewModel.setupAudioNew { url in
				do {
					guard let unwrappedUrl = url else { return }
					audioViewModel.audioPlayer = try AVAudioPlayer(contentsOf: unwrappedUrl)
					audioViewModel.audioPlayer?.numberOfLoops = .zero
				} catch {
					debugPrint("Error URL")
					return
				}
			}
		}
		.onChange(of: playingAudioId, perform: { _ in
			if messageId != playingAudioId {
				audioViewModel.stop()
			}
		})
		.frame(width: 252)
    }
}
