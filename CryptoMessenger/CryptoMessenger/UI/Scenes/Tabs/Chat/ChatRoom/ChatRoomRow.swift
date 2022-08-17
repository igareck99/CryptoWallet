import MatrixSDK
import SwiftUI

// swiftlint:disable:all

// MARK: - ChatRoomRow

struct ChatRoomRow: View {

    // MARK: - Internal Properties

    @State var chatContactInfo = ChatContactInfo(name: "")
    @Binding var activateShowCard: Bool
    @Binding var playingAudioId: String

    // MARK: - Private Properties

    private let message: RoomMessage
    private let isFromCurrentUser: Bool
    private let isPreviousFromCurrentUser: Bool
    private let isDirect: Bool
    private var onReaction: StringBlock?
    private var onSelectPhoto: GenericBlock<URL?>?
    @StateObject var audioViewModel: AudioMessageViewModel

    @State private var showMap = false
    @State private var showFile = false
    @State private var isAnimating = false
    @State private var showContactInfo = false
    @State private var degress = 0.0
    @State private var showLocationTransition = false

    // MARK: - Lifecycle

    init(
        message: RoomMessage,
        isPreviousFromCurrentUser: Bool,
        isDirect: Bool,
        onReaction: StringBlock?,
        onSelectPhoto: GenericBlock<URL?>?,
        activateShowCard: Binding<Bool>,
        playingAudioId: Binding<String>
    ) {
        self.message = message
        self.isFromCurrentUser = message.isCurrentUser
        self.isPreviousFromCurrentUser = isPreviousFromCurrentUser
        self.isDirect = isDirect
        self.onReaction = onReaction
        self.onSelectPhoto = onSelectPhoto
        self._activateShowCard = activateShowCard
        self._playingAudioId = playingAudioId
        switch message.type {
        case let .audio(url):
            self._audioViewModel = StateObject(wrappedValue: AudioMessageViewModel(url: url,
                                                                                   messageId: message.id))
        default:
            let url = URL(string: "")
            self._audioViewModel = StateObject(wrappedValue: AudioMessageViewModel(url: url,
                                                                                   messageId: message.id))
        }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if isFromCurrentUser {
                    Spacer()
                }
                if !isDirect, !isFromCurrentUser {
                    VStack(spacing: 0) {
                        Spacer()
                        AsyncImage(
                            url: message.avatar,
                            placeholder: {
                                ZStack {
                                    Color(.lightBlue())
                                    Text(message.name.firstLetter.uppercased())
                                        .foreground(.white())
                                        .font(.medium(12))
                                }
                            },
                            result: {
                                Image(uiImage: $0).resizable()
                            }
                        )
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .cornerRadius(15)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, -11)
                }
                BubbleView(direction: isFromCurrentUser ? .right : .left) {
                    VStack(alignment: .leading, spacing: 0) {
                        if message.isReply {
                            HStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 1)
                                    .frame(width: 2)
                                    .foreground(.blue(0.9))
                                    .padding(.top, 8)
                                    .padding(.leading, 16)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(message.name,
                                         [
                                            .font(.medium(13)),
                                            .paragraph(.init(lineHeightMultiple: 1.19, alignment: .left)),
                                            .color(.black())
                                        ]
                                    )
                                        .padding(.top, 8)
                                    Text(message.replyDescription,
                                         [
                                            .font(.regular(13)),
                                            .paragraph(.init(lineHeightMultiple: 1.2,
                                                             alignment: .left)),
                                            .color(.black())
                                        ]
                                    )
                                }
                                .frame(minWidth: 0, maxWidth: 70)
                                    .padding(.leading, 8)
                                    .padding(.trailing, 16)
                            }
                            .frame(height: 40)
                        }
                        HStack(spacing: 0) {
                            switch message.type {
                            case let .text(text):
								ChatTextView(
									isFromCurrentUser: isFromCurrentUser,
									shortDate: message.shortDate,
									text: text
								)
                            case let .location(location):
                                mapRow(LocationData(lat: location.lat, long: location.long), date: message.shortDate)
                                    .sheet(isPresented: $showMap) {
                                        NavigationView {
                                            MapView(place: .init(
                                                name: "",
                                                latitude: location.lat,
                                                longitude: location.long
                                            ), showLocationTransition: $showLocationTransition)
                                                .ignoresSafeArea()
                                                .navigationBarTitle(Text(R.string.localizable.chatGeoposition()))
												.navigationBarItems(
													leading: Button(
														R.string.localizable.contactChatDetailClose(),
														action: { showMap.toggle() }
													),
													trailing: Button(
														action: { showLocationTransition = true },
														label: { Image(systemName: "arrowshape.turn.up.forward") }
													)
												)
                                                .navigationBarTitleDisplayMode(.inline)
                                                .navigationBarColor(.white())
                                        }
                                    }
                                    .onTapGesture {
                                        showMap.toggle()
                                    }
                            case let .image(url):
								PhotoView(
									isFromCurrentUser: isFromCurrentUser,
									shortDate: message.shortDate,
									url: url) {
										onSelectPhoto?(url)
									}
                            case let .contact(name, phone, url):
								ContactView(
									shortDate: message.shortDate,
									name: name,
									phone: phone,
									url: url,
									isFromCurrentUser: isFromCurrentUser
								) {
									chatContactInfo = ChatContactInfo(
										name: name,
										phone: phone,
										url: url
									)
									showContactInfo = true
								}
                            case let .file(fileName, url):
								FileView(
									isFromCurrentUser: isFromCurrentUser,
									shortDate: message.shortDate,
									fileName: fileName,
									url: url,
									isShowFile: $showFile,
									sheetPresenting: {
										guard let url = url else { return nil }
										return AnyView(DocumentViewerView(url: url))
									},
									onTapHandler: {
										showFile.toggle()
									})
							case .audio(_):
                                audioRow()
                            case .none:
                                EmptyView()
                            }
                        }
                    }
                    .background(.clear)
                }
                .padding(
                    .top,
                    calculateTopPadding(
                        isCurrentUser: isFromCurrentUser,
                        isPreviousFromCurrentUser: isPreviousFromCurrentUser
                    )
                )
                .padding(isFromCurrentUser ? .leading : .trailing, 8)

                if !isDirect, isFromCurrentUser {
                    VStack(spacing: 0) {
                        Spacer()

                        AsyncImage(
                            url: message.avatar,
                            placeholder: {
                                ZStack {
                                    Color(.lightBlue())
                                    Text(message.name.firstLetter.uppercased())
                                        .foreground(.white())
                                        .font(.medium(12))
                                }
                            },
                            result: {
                                Image(uiImage: $0).resizable()
                            }
                        )
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .cornerRadius(15)
                    }
                    .padding(.trailing, 16)
                    .padding(.leading, -11)
                }

                if !isFromCurrentUser {
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showContactInfo, content: {
            ContactInfoView(data: chatContactInfo)
        })
        .onAppear {
            if !isAnimating {
                isAnimating.toggle()
            }
        }
    }

    // MARK: - Private Methods

    private func mapRow(_ location: LocationData, date: String) -> some View {
        ZStack {
            MapSnapshotView(latitude: location.lat, longitude: location.long)
			CheckReadView(time: date, isFromCurrentUser: isFromCurrentUser)
        }
        .frame(width: 247, height: 142)
    }

    private func audioRow() -> some View {
        return ZStack {
            HStack(alignment: .center, spacing: 12) {
                Button(action: audioViewModel.play) {
                    ZStack {
                        Circle()
                            .frame(width: 48,
                                   height: 48)
                        !audioViewModel.isPlaying ?
						R.image.chat.audio.audioPlay.image :
						R.image.chat.audio.audioStop.image
                    }
                }
                .padding(.vertical, 8)
                .padding(.leading, message.isCurrentUser ? 8 : 16)
                VStack(alignment: .leading, spacing: 10) {
                    SliderAudioView(value: Binding(get: { audioViewModel.time }, set: { newValue in
                        audioViewModel.time = newValue
                        audioViewModel.audioPlayer?.currentTime =
						Double(audioViewModel.time) * (audioViewModel.audioPlayer?.duration ?? 0)
                        audioViewModel.audioPlayer?.play()
                    }), activateShowCard: $activateShowCard)
                    .frame(width: 177, height: 1)
                    Text(message.audioDuration)
                        .font(.regular(12))
                        .foreground(.darkGray())
                }
                .padding(.top, 20)
                .padding(.trailing, 7)
            }
			CheckTextReadView(
				time: message.shortDate,
				isFromCurrentUser: isFromCurrentUser
			).padding(.leading, isFromCurrentUser ? 0 : 185)
        }
        .onReceive(audioViewModel.timer) { _ in
            audioViewModel.onTimerChange()
        }
        .onChange(of: activateShowCard, perform: { _ in
            audioViewModel.stop()
        })
        .onChange(of: audioViewModel.playingAudioId, perform: { value in
            playingAudioId = value
        })
        .onAppear {
            self.audioViewModel.setupAudioNew { url in
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
            if message.id != playingAudioId {
                audioViewModel.stop()
            }
        })
        .frame(width: 252, height: 64)
    }

    private func calculateTopPadding(isCurrentUser: Bool, isPreviousFromCurrentUser: Bool) -> CGFloat {
        if isCurrentUser {
            return isPreviousFromCurrentUser ? 8 : 8
        } else {
            return isPreviousFromCurrentUser ? 8 : 8
        }
    }
}
