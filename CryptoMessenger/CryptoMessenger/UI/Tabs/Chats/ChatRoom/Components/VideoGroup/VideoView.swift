import AVKit
import SwiftUI

// swiftlint:disable all

// MARK: - VideoFeedView

struct VideoView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: VideoViewModel

    // MARK: - Private Properties

    @State private var selectedVideo: Video?
    @State private var embeddedVideoRate: Float = 0.0
    @State private var embeddedVideoVolume: Float = 0.0
    @State private var shouldShowEmbeddedVideoInPiP = false
    @State private var videoUrl: URL?
    @State private var videoState = FileStates.error
    private let isFromCurrentUser: Bool
    private let shortDate: String
	private let reactionItems: [ReactionTextsItem]
	@State private var totalHeight: CGFloat = .zero

    // MARK: - Private Properties

    init(
        isFromCurrentUser: Bool,
        shortDate: String,
		reactionItems: [ReactionTextsItem],
        viewModel: VideoViewModel
    ) {
        self.isFromCurrentUser = isFromCurrentUser
        self.shortDate = shortDate
		self.reactionItems = reactionItems
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

	var body: some View {
		Group {
			VStack(alignment: .leading, spacing: 0) {
				ZStack(alignment: .center) {
					ZStack {
						VideoRow(viewModel: viewModel)
							.scaledToFill()
							.frame(width: 202, height: 245)
						HStack {
							makeVideoInfoView()
								.padding(.bottom, 215)
								.padding(.leading, 10)
							CheckReadView(time: shortDate,
										  isFromCurrentUser: isFromCurrentUser)
							.padding(.leading, isFromCurrentUser ? 0 : 130)
						}
					}
					.scaledToFill()
					.frame(width: 202, height: 245)
					.cornerRadius(16)
					makePlayView()
						.cornerRadius(16)
				}

				ReactionsGrid(
					totalHeight: $totalHeight,
                    viewModel: ReactionsGroupViewModel(items: reactionItems)
				)
				.frame(
                    minHeight: totalHeight == 0 ? viewHeightNew(for: 202, reactionItems: reactionItems) : totalHeight
				)
				.padding([.top, .bottom], 8)
				.padding(.trailing, 8)
			}
			.frame(width: 202)
			.cornerRadius(16)
			.onTapGesture {
				if viewModel.isVideoUpload {
					selectedVideo = Video(videoUrl: viewModel.videoUrl)
				}
			}
		}
		.frame(width: 202)
		.cornerRadius(16)
		.fullScreenCover(item: $selectedVideo) {
			embeddedVideoRate = 1.0
		} content: { _ in
			makeFullScreenVideoPlayer()
		}
		.onChange(of: viewModel.dataUrl) { value in
			if value != nil {
				viewModel.isVideoUpload = true
				videoUrl = value
			}
		}
	}

    // MARK: - ViewBuilder

    @ViewBuilder
    private func makeVideoInfoView() -> some View {
        ZStack {
            if viewModel.isVideoUpload {
                Text("\(viewModel.videoDuration)")
                    .foregroundColor(.white)
                    .font(.caption1Regular12)
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(Color.chineseBlack04)
                    .frame(width: 32, height: 14)
            } else {
                Text("\(viewModel.videoSize)")
                    .foregroundColor(.white)
                    .font(.caption1Regular12)
                    .lineLimit(1)
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(Color.chineseBlack04)
                    .frame(width: 102, height: 16)
            }
        }
    }

    @ViewBuilder
    private func makePlayView() -> some View {
        ZStack(alignment: .center) {
            if viewModel.isVideoUpload {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.chineseBlack04)
                Image(systemName: "play.fill")
                    .resizable()
                    .tint(.white)
                    .frame(width: 15, height: 15)
            } else {
                ProgressView()
                    .frame(width: 48, height: 48)
            }
        }
    }

    @ViewBuilder
    private func makeFullScreenVideoPlayer() -> some View {
        if let url = viewModel.dataUrl {
            let avPlayer = AVPlayer(url: url)
            VideoPlayerView(player: avPlayer)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    embeddedVideoRate = 0.0
                }
        } else {
            ErrorView()
        }
    }
}
