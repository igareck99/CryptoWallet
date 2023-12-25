import Combine
import SwiftUI

// swiftlint:disable all
// MARK: - ChatRoomView

struct ChatRoomView: View {

    // MARK: - ActiveSheet

    enum ActiveSheet: Identifiable {

        // MARK: - Types

        case photo, documents, camera, contact, location

        // MARK: - Internal Properties

        var id: Int { hashValue }
    }

    // MARK: - Internal Properties

    @StateObject var viewModel: ChatRoomViewModel
    @StateObject var attachViewModel = AttachActionViewModel(isDirectChat: false, tappedAction: { _ in  }, onCamera: {  }, onSendPhoto: { _ in  } )
    @State var photosToSend: [UIImage] = []
    @State var playingAudioId = ""
    @State var sendPhotos = false
    @State var showAudioView = false
    @State var record: RecordingDataModel?
    @State var blockDragPadding: CGFloat = 0
    @State private var textDragPadding: CGFloat = 0
    @State var blockAudioRecord = false
    @State var resetAudio = false
    @State var activateShowCard = true
	@State var textViewHeight: CGFloat = 36
    @State var showReaction = false
    @State var viewHeight: CGFloat = 68
    @State var isLeaveChannel = false

    // MARK: - Private Properties

    @StateObject private var keyboardHandler = KeyboardHandler()
    @Environment(\.presentationMode) private var presentationMode
    @State private var messageId = ""
    @State private var showCamera = false
    @State private var cardPosition: CardPosition = .bottom
    @State private var cardGroupPosition: CardPosition = .bottom
    @State private var translateCardPosition: CardPosition = .bottom
    @State private var scrolled = false
    @State private var showActionSheet = false
    @State private var height = CGFloat(0)
    @State private var inputHeight = CGFloat(0)
    @State private var selectedPhoto: URL?
    @State private var showImageViewer = false
    @State private var showSettings = false
    @State private var showTranslateAlert = false
    @State private var showTranslateMenu = false
    @State private var activeEditMessage: RoomMessage?
    @State private var deleteMessage: RoomMessage?
    @State private var quickAction: QuickActionCurrentUser?
    @State private var testAvatarUrl: URL?
    @State private var showNotificationsChangeView = false

    @FocusState private var inputViewIsFocused: Bool

	private var statusBarHeight: CGFloat {
		(UIApplication.shared.connectedScenes.first as? UIWindowScene)?
			.statusBarManager?
			.statusBarFrame
			.size
			.height ?? .zero
	}
    
    
    // MARK: - Body

    var body: some View {
        content
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                viewModel.send(.onAppear(nil))
                UITextView.appearance().background(.ashGray)
            }
            .onChange(of: showActionSheet, perform: { _ in
                if sendPhotos {
                    viewModel.sendPhotos(images: photosToSend)
                }
                photosToSend = []
            })
            .onReceive(viewModel.$roomAvatarUrl, perform: { value in
                guard let url = value else { return }
                testAvatarUrl = url
            })
            .onChange(of: viewModel.dismissScreen, perform: { newValue in
                if newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .onChange(of: isLeaveChannel, perform: { newValue in
                if newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .onReceive(viewModel.$showTranslate) { flag in
                if flag {
                    showTranslateAlert = true
                }
            }
            .popup(
                isPresented: $showReaction,
                type: .toast,
                position: .bottom,
                closeOnTap: false,
                closeOnTapOutside: true,
                backgroundColor: viewModel.resources.backgroundFodding,
                view: {
                    ReactionsViewList(viewModel: ReactionsViewModel(activeEditMessage: activeEditMessage))
                    .background(
                        CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                            .fill(viewModel.resources.background)
                    )
                    .frame(height: 178)
                }
            )
            .fullScreenCover(isPresented: self.$showImageViewer,
                             content: {
                ImageViewerRemote(imageURL: $selectedPhoto,
                                  viewerShown: self.$showImageViewer,
                                  deleteActionAvailable: false,
                                onDelete: {
                    debugPrint("OnDelete")
                }, onShare: {
                    debugPrint("onShare")
                })
                    .ignoresSafeArea()
                    .navigationBarHidden(true)
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(selectedPhoto != nil && showImageViewer ? nil : viewModel.resources.background, isBlured: false)
            .toolbar {
                createToolBar()
            }
            .toolbar(.hidden, for: .tabBar)
    }

    private var content: some View {
        ZStack {
            Color(.aliceBlue)
            VStack(spacing: 0) {
                ScrollViewReader { scrollView in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(viewModel.messages) { event in
                                if viewModel.isTranslating() {
                                    if let message = viewModel.translatedMessages.first(where: {$0.eventId == event.eventId}) {
                                        ChatRoomRow(
                                            message: message,
                                            isPreviousFromCurrentUser: viewModel.previous(message)?.isCurrentUser ?? false,
											// TODO: Пока отключил автарки в чатах, т.к. в андроиде их тоже нет
											isDirect: true,// viewModel.room.isDirect,
                                            onReaction: { reactionId in
                                                vibrate()
                                                viewModel.send(
                                                    .onDeleteReaction(messageId: message.id, reactionId: reactionId)
                                                )
                                            },
                                            onSelectPhoto: {
                                                selectedPhoto = $0
                                                showImageViewer = true
                                                hideKeyboard()
                                            },
											onEmojiTap: { viewModel.react(toEventId: $0.1, emoji: $0.0) },
                                            activateShowCard: $activateShowCard,
                                            playingAudioId: $playingAudioId
                                        )
                                        .flippedUpsideDown()
                                        .listRowSeparator(.hidden)
                                        .onLongPressGesture(minimumDuration: 0.05, maximumDistance: 0) {
                                            vibrate(.medium)
                                            if activateShowCard {
                                                messageId = message.id
                                                activeEditMessage = message
                                                cardPosition = .custom(UIScreen.main.bounds.height - 580)
                                            }
                                            hideKeyboard()
                                        }
                                    }
                                } else {
                                    if let message = viewModel.messages.first(where: {$0.eventId == event.eventId}) {
                                        ChatRoomRow(
                                            message: message,
                                            isPreviousFromCurrentUser: viewModel.previous(message)?.isCurrentUser ?? false,
											// TODO: Пока отключил автарки в чатах, т.к. в андроиде их тоже нет
                                            isDirect: true,//viewModel.room.isDirect,
                                            onReaction: { reactionId in
                                                vibrate()
                                                viewModel.send(
                                                    .onDeleteReaction(messageId: message.id, reactionId: reactionId)
                                                )
                                            },
                                            onSelectPhoto: {
												hideKeyboard()
												selectedPhoto = $0
                                                showImageViewer = true
                                                hideKeyboard()
											},
											onEmojiTap: { viewModel.react(toEventId: $0.1, emoji: $0.0) },
                                            activateShowCard: $activateShowCard,
                                            playingAudioId: $playingAudioId
                                        )
										.addSwipeAction(
											menu: .swiped,
											edge: .trailing,
											isSwiped: .constant(false),
											action: {
												debugPrint("addSwipeAction")
												activeEditMessage = message
												inputViewIsFocused = true
												quickAction = .reply
										}, {
											Rectangle()
												.frame(width: 70, alignment: .center)
												.frame(maxHeight: .infinity)
												.foregroundColor(.clear)
										})
                                        .onTapGesture {
											hideKeyboard()
                                            DispatchQueue.main.async {
                                                viewModel.channelTransition(message)
                                            }
										}
                                        .flippedUpsideDown()
                                        .listRowSeparator(.hidden)
                                        .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 0) {
                                            vibrate(.medium)
                                            if activateShowCard {
                                                messageId = message.id
                                                activeEditMessage = message
                                                cardPosition = .custom(UIScreen.main.bounds.height - 580)
                                            }
                                            hideKeyboard()
                                        }
                                    }
                                }
                                viewModel.makeChatEventView(event: event)
                            }
                            .onChange(of: viewModel.messages) { _ in
                                viewModel.markAllReaded()
                                guard let id = viewModel.messages.first?.id else { return }
                                withAnimation {
                                    scrollView.scrollTo(id, anchor: .bottom)
                                }
                            }
                            .onAppear {
                                guard let id = viewModel.messages.first?.id else { return }
                                withAnimation {
                                    scrollView.scrollTo(id, anchor: .bottom)
                                }
                            }
                        }
					}.safeAreaInset(edge: .bottom, content: {
						Spacer().frame(height: statusBarHeight + 42 + (keyboardHandler.keyboardHeight == 0 ? 0 : 84))
					})
					.safeAreaInset(edge: .top, content: {
						Spacer().frame(height: 16)
					})
                    .flippedUpsideDown()
                }
                VStack(spacing: 0) {
                    if quickAction == .reply {
                        ReplyView(
                            text: activeEditMessage?.description ?? "", viewType: .reply,
                            onReset: { activeEditMessage = nil; quickAction = nil }
                        ).transition(.opacity)
                    }
                    if quickAction == .edit {
                        ReplyView(
                            text: activeEditMessage?.description ?? "", viewType: .edit,
                            onReset: { activeEditMessage = nil; quickAction = nil }
                        ).transition(.opacity)
                    }
                    if viewModel.userHasAccessToMessage {
                        inputView
                    } else {
                        accessDeniedView
                    }
                }
            }
            .animation(.easeInOut(duration: 0.23), value: keyboardHandler.keyboardHeight != 0)
            .padding(.bottom, keyboardHandler.keyboardHeight)
            
            if showActionSheet {
                ActionSheetView(
                    showActionSheet: $showActionSheet,
                    attachAction: $viewModel.attachAction,
                    sendPhotos: $sendPhotos,
                    imagesToSend: $photosToSend,
                    onCamera: {
                        showActionSheet = false
                        viewModel.send(
                            .onCamera(
                                $viewModel.selectedImage,
                                $viewModel.selectedVideo
                            )
                        )
                    },
                    viewModel: attachViewModel
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            if activateShowCard {
                quickMenuView
            }
            if viewModel.room.isDirect {
                directMenuView
            } else {
                groupMenuView
            }
            //translateMenuView
        }
        .hideKeyboardOnTap()
		.ignoresSafeArea()
    }

    private var quickMenuView: some View {
        ZStack {
            Color(cardPosition == .bottom ? .clear : .chineseBlack04)
                .ignoresSafeArea()
                .animation(.easeInOut, value: cardPosition != .bottom)
                .onTapGesture {
                    vibrate()
                    cardPosition = .bottom
                }
            SlideCard(position: $cardPosition,
                      expandedPosition: .custom(UIScreen.main.bounds.height - 580)) {
                VStack {
                    if let message = activeEditMessage {
                        RoomMessageMenuAssembly.build(messageType: activeEditMessage?.type ?? .none,
                                                      hasReactions: !(activeEditMessage?.reactions.isEmpty ?? false),
                                                      hasAccessToWrite: viewModel.userHasAccessToMessage,
                                                      isCurrentUser: activeEditMessage?.isCurrentUser ?? true,
                                                      isChannel: viewModel.isChannel,
                                                      userRole: viewModel.getUserRole(),
                                                      onAction: {
                            switch $0 {
                            case .copy:
                                viewModel.onCopyTap(text: message.description)
                            case .delete:
                                viewModel.send(.onDelete(messageId))
                            case .edit:
                                inputViewIsFocused = true
                            case .reply:
                                inputViewIsFocused = true
                                quickAction = .reply
                            case .reaction:
                                if viewModel.isReactionsAvailable {
                                    showReaction = true
                                }
                            default:
                                ()
                            }
                            quickAction = $0
                        }, onReaction: { reaction in
                            debugPrint("emotions \(reaction)")
                            viewModel.send(.onAddReaction(messageId: message.id, reactionId: reaction))
                            
                        })
                    }
                }
            }
        }
    }

    private var groupMenuView: some View {
        ZStack {
            Color(cardGroupPosition == .bottom ? .clear : .chineseBlack04)
                .ignoresSafeArea()
                .animation(.easeInOut, value: cardGroupPosition != .bottom)
                .onTapGesture {
                    vibrate()
                    cardGroupPosition = .bottom
                }
        }
    }
    
    
    private var directMenuView: some View {
        ZStack {
            Color(cardGroupPosition == .bottom ? .clear : .chineseBlack04)
                .ignoresSafeArea()
                .animation(.easeInOut, value: cardGroupPosition != .bottom)
                .onTapGesture {
                    vibrate()
                    cardGroupPosition = .bottom
                }

            SlideCard(position: $cardGroupPosition) {
                VStack(spacing: 0) {
                    DirectMenuView(viewModel: DirectChatMenuViewModel(room: viewModel.room, showNotificationsChangeView: $showNotificationsChangeView),
                                   action: $viewModel.directAction,
                                   cardGroupPosition: $cardGroupPosition,
                                   onMedia: { viewModel.send(.onMedia(viewModel.room)) })
                }.padding(.vertical, 32)
            }
        }
    }

    private var translateMenuView: some View {
        ZStack {
            Color(translateCardPosition == .bottom ? .clear : .chineseBlack04)
                .ignoresSafeArea()
                .animation(.easeInOut, value: translateCardPosition != .bottom)
                .onTapGesture {
                    vibrate()
                    translateCardPosition = .bottom
                }

            SlideCard(position: $translateCardPosition, expandedPosition: .custom(UIScreen.main.bounds.height - 630)) {
                VStack(spacing: 0) {
                    TranslateMenuView(action: $viewModel.translateAction, translateCardPosition: $translateCardPosition)
                }.padding(.vertical, 32)
            }
        }
    }
    
    private var accessDeniedView: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("У вас нет разрешения на публикацию в этом канале")
                .font(.subheadlineRegular15)
                .foregroundColor(.romanSilver)
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }

    private var inputView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    if showAudioView {
                        HStack(alignment: .center) {
                            AudioInputMessageView(audioUrl: $viewModel.audioUrl,
                                                  showAudioView: $showAudioView,
                                                  blockAudioRecord: $blockAudioRecord,
                                                  textDragPadding: $textDragPadding,
                                                  blockDragPadding: $blockDragPadding,
                                                  resetAudio: $resetAudio,
                                                  sendAudio: $resetAudio, recordOnSend: { _ in
                                
                            })
                            .ignoresSafeArea()
                            .padding(.leading, 12)
                            .padding(.trailing, 8)
                        }
                    } else {
                        Button(action: {
                            hideKeyboard()
                            withAnimation {
                                showActionSheet.toggle()
                            }
                        }, label: {
                            viewModel.resources.plus
                                .resizable()
                                .frame(width: 24, height: 24)
                        })
                        .padding(.leading, 8)
                        HStack {
                            ResizeableTextView(
                                text: $viewModel.inputText,
                                height: $textViewHeight,
                                placeholderText: "Сообщение..."
                            )
                            .focused($inputViewIsFocused)
                            .keyboardType(.default)
                            .clipShape(RoundedRectangle(cornerRadius: 16,
                                                        style: .continuous))
                            .padding(.horizontal, 16)
                        }
                        .padding(.trailing, viewModel.inputText.isEmpty ? 0 : 8)
                    }
                    if !viewModel.inputText.isEmpty {
                        Button(action: {
                            withAnimation {
                                if quickAction == .reply {
                                    viewModel.send(.onReply(viewModel.inputText, activeEditMessage?.eventId ?? ""))
                                    viewModel.inputText = ""
                                    activeEditMessage = nil
                                    quickAction = nil
                                } else if quickAction == .edit {
                                    viewModel.send(.onEdit(viewModel.inputText, activeEditMessage?.eventId ?? ""))
                                    viewModel.inputText = ""
                                    activeEditMessage = nil
                                    quickAction = nil
                                    viewModel.send(.onSendText(viewModel.inputText))
                                } else {
                                    viewModel.send(.onSendText(viewModel.inputText))
                                }
                                textViewHeight = 36
                            }
                        }, label: {
                            viewModel.resources.paperPlane
                                .foregroundColor(.dodgerBlue)
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 16)
                    } else {
                        MicrophoneMessageView(showAudioView: $showAudioView,
                                              blockDragPadding: $blockDragPadding,
                                              blockAudioRecord: $blockAudioRecord,
                                              textDragPadding: $textDragPadding,
                                              resetAudio: $resetAudio, sendAudio: $resetAudio)
                        .frame(width: 24,
                               height: 24)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .frame(height: min(18 + textViewHeight, 160))
            .background(Color.white)
            .ignoresSafeArea()

            Rectangle()
                .fill(Color.white)
                .frame(height: keyboardHandler.keyboardHeight == 0 ? 24 : 0)
        }
    }
    
    // MARK: - Private methods
    
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack(spacing: 0) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    viewModel.resources.backButton
                })
                AsyncImage(
                    defaultUrl: $testAvatarUrl.wrappedValue,
                    updatingPhoto: true,
                    url: $testAvatarUrl,
                    isAvatarLoading: $viewModel.isAvatarLoading,
                    placeholder: {
                        ZStack {
                            Color.aliceBlue
                            Text(viewModel.room.summary.summary?.displayName?.firstLetter.uppercased() ?? "?")
                                .foregroundColor(.white)
                                .font(.title3Semibold20)
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 36, height: 36)
                .cornerRadius(18)
                .padding(.trailing, 12)
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(viewModel.room.summary.summary?.displayName ?? "")
                            .lineLimit(1)
                            .font(.subheadlineMedium15)
                            .foregroundColor(.chineseBlack)
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        if viewModel.room.isDirect {
                            Text(viewModel.room.isOnline ?  viewModel.resources.chatOnline :
                                    viewModel.resources.chatOffline)
                            .lineLimit(1)
                            .font(.footnoteRegular13)
                            .foregroundColor(viewModel.room.isOnline ? .dodgerBlue : .chineseBlack04)
                        } else {
                            Text("Участники (\(viewModel.participants.count))")
                                .lineLimit(1)
                                .font(.footnoteRegular13)
                                .foregroundColor(.chineseBlack04)
                        }
                        Spacer()
                    }
                }
//                .alert(isPresented: $showTranslateAlert) {
//                    let dismissButton = Alert.Button.default(Text(viewModel.resources.translateChange)) {
//                        translateCardPosition = .custom(UIScreen.main.bounds.height - 630)
//                    }
//                    let confirmButton = Alert.Button.default(Text(viewModel.resources.translate)) {
//                        for message in viewModel.messages {
//                            viewModel.translateTo(languageCode: "ru", message: message)
//                        }
//                    }
//                    return Alert(title: Text(viewModel.resources.translateIntoRussian),
//                                 message: Text(viewModel.resources.translateAlertEncryption),
//                                 primaryButton: confirmButton, secondaryButton: dismissButton)
//                }
//                .frame(width: 160)
                
                Spacer()
            }
            .background(Color.white)
            .onTapGesture {
                viewModel.send(.onSettings(chatData: $viewModel.chatData,
                                           saveData: $viewModel.saveData,
                                           room: viewModel.room,
                                           isLeaveChannel: $isLeaveChannel))
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 8) {
                if viewModel.isVideoCallAvailable {
                    Button(action: {
                        viewModel.p2pVideoCallPublisher.send()
                    }, label: {
                        viewModel.resources.videoFill.tint(.chineseBlack)
                    }).disabled(!$viewModel.isVideoCallAvailablility.wrappedValue)
                }
                if viewModel.isVoiceCallAvailable {
                    Button(action: {
                        viewModel.p2pVoiceCallPublisher.send()
                    }, label: {
                        viewModel.resources.phoneFill.tint(.chineseBlack)
                    }).disabled(!$viewModel.isVoiceCallAvailablility.wrappedValue)
                }
				if viewModel.isGroupCall {
					Button(action: {
						viewModel.groupCallPublisher.send()
					}, label: {
						viewModel.resources.videoFill.tint(.chineseBlack)
					})
				}
                if viewModel.getMenuStatus() {
                    Button(action: {
                        hideKeyboard()
                        cardGroupPosition = .custom(UIScreen.main.bounds.height - 250)
                    }, label: {
                        viewModel.resources.settingsButton
                    })
                    .padding(.trailing, 6)
                }
            }
        }
    }
    
    private func getSizeOfSlideCard() -> CGFloat {
        guard let message = activeEditMessage else { return CGFloat(0) }
        if viewModel.isChannel {
            switch viewModel.getUserRole() {
            case .owner:
                return UIScreen.main.bounds.height - 580
            case .admin:
                return UIScreen.main.bounds.height - 580
            case .user:
                return UIScreen.main.bounds.height - 720
            case .unknown:
                return UIScreen.main.bounds.height - 580
            }
        }
        return UIScreen.main.bounds.height - 580
    }
}

