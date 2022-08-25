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
	private let viewModel: ChatRoomRowViewModelProtocol

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
							viewModel.makeChatMessageEventView(
								showFile: $showFile,
								showMap: $showMap,
								showLocationTransition: $showLocationTransition,
								activateShowCard: $activateShowCard,
								playingAudioId: $playingAudioId,
								onSelectPhoto: onSelectPhoto,
								onContactButtonAction: { name, phone , url in
										chatContactInfo = ChatContactInfo(
										name: name,
										phone: phone,
										url: url
									)
									showContactInfo = true
								},
								onFileTapHandler: {
									showFile.toggle()
								},
								fileSheetPresenting: { fileUrl in
									guard let url = fileUrl else { return nil }
									return AnyView(DocumentViewerView(url: url))
								},
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
}
