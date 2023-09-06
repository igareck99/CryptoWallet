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
	private let onEmojiTap: GenericBlock<(emoji: String, messageId: String)>
	private let viewModel: ChatRoomRowViewModelProtocol

    @State private var showMap = false
    @State private var showFile = false
    @State private var isAnimating = false
    @State private var showContactInfo = false
    @State private var degress = 0.0
    @State private var showLocationTransition = false
    @State private var isUploadFinished = false
    @State private var documentViewmodel: DocumentViewerViewModel?

    // MARK: - Lifecycle

	init(
		message: RoomMessage,
		isPreviousFromCurrentUser: Bool,
		isDirect: Bool,
		onReaction: StringBlock?,
		onSelectPhoto: GenericBlock<URL?>?,
		onEmojiTap: @escaping GenericBlock<(emoji: String, messageId: String)>,
		activateShowCard: Binding<Bool>,
		playingAudioId: Binding<String>,
		viewModel: ChatRoomRowViewModelProtocol = ChatRoomRowViewModel()
	) {
		self.viewModel = viewModel
        self.message = message
        self.isFromCurrentUser = message.isCurrentUser
        self.isPreviousFromCurrentUser = isPreviousFromCurrentUser
        self.isDirect = isDirect
        self.onReaction = onReaction
        self.onSelectPhoto = onSelectPhoto
		self.onEmojiTap = onEmojiTap
        self._activateShowCard = activateShowCard
        self._playingAudioId = playingAudioId
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
                            defaultUrl: message.avatar,
                            placeholder: {
                                ZStack {
                                    Color.dodgerBlue
                                    Text(message.name.firstLetter.uppercased())
                                        .foregroundColor(.white)
                                        .font(.system(size: 12, weight: .medium))
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
                BubbleView(
					direction: isFromCurrentUser ? .right : .left,
					shouldShowBackground: viewModel.shouldShowBackground(message: message)
				) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
							viewModel.makeChatMessageEventView(
								showFile: $showFile,
								showMap: $showMap,
								showLocationTransition: $showLocationTransition,
								activateShowCard: $activateShowCard,
								playingAudioId: $playingAudioId,
								onSelectPhoto: onSelectPhoto,
								onContactButtonAction: { name, phone, url in
										chatContactInfo = ChatContactInfo(
										name: name,
										phone: phone,
										url: url
									)
									showContactInfo = true
								},
                                onFileTapHandler: { fileUrl in
                                    DispatchQueue.global(qos: .background).async {
                                        if let fileUrl = fileUrl {
                                            var name = ""
                                            switch message.type {
                                            case let .file(fileName, _):
                                                name = fileName
                                            default:
                                                break
                                            }
                                            self.documentViewmodel = DocumentViewerViewModel(
                                                url: fileUrl,
                                                isUploadFinished: $isUploadFinished,
                                                fileName: name
                                            )
                                            showFile = true
                                        }
                                    }
								}, onEmojiTap: { onEmojiTap($0) },
								message: message
							)
                        }
                    }
                    .background(.clear)
                }
                .padding(.top, 8)
                .padding(isFromCurrentUser ? .leading : .trailing, 8)

                if !isDirect, isFromCurrentUser {
                    VStack(spacing: 0) {
                        Spacer()
                        AsyncImage(
                            defaultUrl: message.avatar,
                            placeholder: {
                                ZStack {
                                    Color.dodgerBlue
                                    Text(message.name.firstLetter.uppercased())
                                        .foregroundColor(.white)
                                        .font(.system(size: 12, weight: .medium))
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
        .sheet(isPresented: $showFile, content: {
            if let vm = documentViewmodel {
                PreviewControllerView(viewModel: vm)
            }
        })
        .sheet(isPresented: $showContactInfo, content: {
            ContactInfoView(
                viewModel: ContactInfoViewModel(),
                data: chatContactInfo
            )
        })
        .onAppear {
            if !isAnimating {
                isAnimating.toggle()
            }
        }
    }
}
