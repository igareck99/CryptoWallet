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
    @StateObject var attachViewModel = AttachActionViewModel()
    @State var photosToSend: [UIImage] = []
    @State var playingAudioId = ""
    @State var sendPhotos = false
    @StateObject var attachActionViewModel = AttachActionViewModel()
    @State var showAudioView = false
    @State var record: RecordingDataModel?
    @State var blockDragPadding: CGFloat = 0
    @State private var textDragPadding: CGFloat = 0
    @State var blockAudioRecord = false
    @State var resetAudio = false
    @State var activateShowCard = true
	@State var textViewHeight: CGFloat = 36
    @State var showReaction = false

    // MARK: - Private Properties

    @StateObject private var keyboardHandler = KeyboardHandler()
    @Environment(\.presentationMode) private var presentationMode
    @State private var messageId = ""
    @State private var cardPosition: CardPosition = .bottom
    @State private var cardGroupPosition: CardPosition = .bottom
    @State private var translateCardPosition: CardPosition = .bottom
    @State private var scrolled = false
    @State private var showActionSheet = false
    @State private var showJoinAlert = false
    @State private var height = CGFloat(0)
    @State private var selectedPhoto: URL?
    @State private var showSettings = false
    @State private var showTranslateAlert = false
    @State private var showTranslateMenu = false
    @State private var activeSheet: ActiveSheet?
    @State private var activeEditMessage: RoomMessage?
    @State private var deleteMessage: RoomMessage?
    @State private var quickAction: QuickAction?
    @State private var quickActionCurrentUser: QuickActionCurrentUser?

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
            .onAppear {
                viewModel.send(.onAppear)
                viewModel.notificationsStatus(.muteOn)
                hideTabBar()
                switch viewModel.room.summary.membership {
                case .invite:
                    showJoinAlert = true
                case .join:
                    viewModel.room.markAllAsRead()
                default:
                    break
                }
                UITextView.appearance().background(.grayDAE1E9())
            }
            .onChange(of: showActionSheet, perform: { _ in
                if sendPhotos {
                    viewModel.sendPhotos(images: photosToSend)
                }
                photosToSend = []
            })
            .onDisappear {
                showTabBar()
                viewModel.notificationsStatus(.allMessagesOn)
            }
            .onChange(of: viewModel.dismissScreen, perform: { newValue in
                if newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .onChange(of: showActionSheet, perform: { item in
                if item {
                    hideNavBar()
                } else {
                    showNavBar()
                }
            })
            .onReceive(viewModel.$showPhotoLibrary) { flag in
                if flag { activeSheet = .photo }
            }
            .onReceive(viewModel.$showDocuments) { flag in
                if flag { activeSheet = .documents }
            }
            .onReceive(viewModel.$showContacts, perform: { flag in
                if flag { activeSheet = .contact }
            })
            .onReceive(viewModel.$showTranslate) { flag in
                if flag {
                    showTranslateAlert = true
                }
            }
            .onReceive(viewModel.$showLocationPicker) { flag in
                if flag {
                    activeSheet = .location
                }
            }
            .popup(
                isPresented: $showReaction,
                type: .toast,
                position: .bottom,
                closeOnTap: false,
                closeOnTapOutside: true,
                backgroundColor: .black.opacity(0.4),
                view: {
                    ReactionsViewList(viewModel: ReactionsViewModel(activeEditMessage: activeEditMessage))
                    .background(
                        CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                            .fill(Color(.white()))
                    )
                    .frame(height: 178)
                }
            )
            .sheet(item: $activeSheet) { item in
                switch item {
                case .photo:
                    GalleryPickerView(selectedImage: $viewModel.selectedImage,
                                      selectedVideo: $viewModel.selectedVideo)
                        .navigationBarTitle(Text(viewModel.sources.photoEditorTitle))
                        .navigationBarTitleDisplayMode(.inline)
                case .documents:
                    documentPicker { urls in
                        guard !urls.isEmpty, let url = urls.first else { return }
                        self.viewModel.send(.onSendFile(url))
                    }
                case .camera:
                    GalleryPickerView(selectedImage: $viewModel.selectedImage,
                                      selectedVideo: $viewModel.selectedVideo,
                                      sourceType: .camera)
                            .navigationBarTitleDisplayMode(.inline)
                            .edgesIgnoringSafeArea(.all)
                case .contact:
                    NavigationView {
                        SelectContactView(viewModel: SelectContactViewModel(mode: .send), contactsLimit: 1,
                                          onSelectContact: {
                            viewModel.pickedContact = $0
                        })
                    }
                case .location:
                    NavigationView {
                        LocationPickerView(place: $viewModel.pickedLocation,
                                           sendLocation: $viewModel.sendLocationFlag)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(selectedPhoto != nil ? nil : .white(), isBlured: false)
            .toolbar {
                createToolBar()
            }
    }

    private var content: some View {
        ZStack {
            Color(.blueABC3D5())
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
                                            onSelectPhoto: { selectedPhoto = $0 },
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
                                viewModel.room.markAllAsRead()
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
                inputView
            }
            .animation(.easeInOut(duration: 0.23), value: keyboardHandler.keyboardHeight != 0)
            .padding(.bottom, keyboardHandler.keyboardHeight)

            if showActionSheet {
                ActionSheetView(
                    showActionSheet: $showActionSheet,
                    attachAction: $viewModel.attachAction,
                    cameraFrame: $viewModel.cameraFrame,
                    sendPhotos: $sendPhotos,
                    imagesToSend: $photosToSend,
                    onCamera: { showActionSheet = false; activeSheet = .camera },
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
            translateMenuView
            if selectedPhoto != nil {
                ZStack {
                    ImageViewer(
                        selectedPhoto: $selectedPhoto,
                        allImages: [],
                        selectedImageID: ""
                    )
                        .navigationBarHidden(true)
                        .ignoresSafeArea()
                }
            }
        }
        .hideKeyboardOnTap()
		.ignoresSafeArea()
    }

    private var quickMenuView: some View {
        ZStack {
            Color(cardPosition == .bottom ? .clear : .black(0.4))
                .ignoresSafeArea()
                .animation(.easeInOut, value: cardPosition != .bottom)
                .onTapGesture {
                    vibrate()
                    cardPosition = .bottom
                }

            SlideCard(position: $cardPosition,
                      expandedPosition: .custom(UIScreen.main.bounds.height - 580)) {
                VStack {
                    if let message = activeEditMessage,
						let current = message.isCurrentUser {
						if current {
							QuickMenuCurrentUserView(
								cardPosition: $cardPosition,
								onAction: {
									switch $0 {
									case .copy:
										UIPasteboard.general.string = message.description
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
									quickActionCurrentUser = $0
								},
								onReaction: { reaction in
									debugPrint("emotions \(reaction)")
									viewModel.send(.onAddReaction(messageId: message.id, reactionId: reaction))
								}
							).padding(.vertical, 16)
                        } else {
							QuickMenuView(
								cardPosition: $cardPosition,
								onAction: {
									switch $0 {
									case .copy:
										UIPasteboard.general.string = activeEditMessage?.description
									case .delete:
										viewModel.send(.onDelete(messageId))
									case .reply:
										inputViewIsFocused = true
									case .reaction:
										if viewModel.isReactionsAvailable {
											debugPrint("emotions \(activeEditMessage)")
											showReaction = true
										}
									default:
										()
									}
									quickAction = $0
								},
                                onReaction: { reaction in
                                    debugPrint("emotions \(reaction)")
                                    viewModel.send(.onAddReaction(messageId: message.id, reactionId: reaction))
                                }
							).padding(.vertical, 16)
                        }
                    }
                }
            }
        }
    }

    private var groupMenuView: some View {
        ZStack {
            Color(cardGroupPosition == .bottom ? .clear : .black(0.4))
                .ignoresSafeArea()
                .animation(.easeInOut, value: cardGroupPosition != .bottom)
                .onTapGesture {
                    vibrate()
                    cardGroupPosition = .bottom
                }

            SlideCard(position: $cardGroupPosition) {
                VStack(spacing: 0) {
                    GroupMenuView(action: $viewModel.groupAction,
                                  cardGroupPosition: $cardGroupPosition)
                }.padding(.vertical, 32)
            }
        }
    }
    
    
    private var directMenuView: some View {
        ZStack {
            Color(cardGroupPosition == .bottom ? .clear : .black(0.4))
                .ignoresSafeArea()
                .animation(.easeInOut, value: cardGroupPosition != .bottom)
                .onTapGesture {
                    vibrate()
                    cardGroupPosition = .bottom
                }

            SlideCard(position: $cardGroupPosition) {
                VStack(spacing: 0) {
                    DirectMenuView(viewModel: DirectChatMenuViewModel(room: viewModel.room),
                                   action: $viewModel.directAction,
                                   cardGroupPosition: $cardGroupPosition)
                }.padding(.vertical, 32)
            }
        }
    }

    private var translateMenuView: some View {
        ZStack {
            Color(translateCardPosition == .bottom ? .clear : .black(0.4))
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

    private var inputView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                if quickAction == .reply {
                    ReplyView(
                        text: activeEditMessage?.description ?? "",
                        onReset: { activeEditMessage = nil; quickAction = nil }
                    ).transition(.opacity)
                }
                if quickActionCurrentUser == .edit {
                    EditView(
                        text: activeEditMessage?.description ?? "",
                        onReset: { activeEditMessage = nil; quickActionCurrentUser = nil }
                    ).transition(.opacity)
                }

                HStack(spacing: 8) {
                    if showAudioView {
                        HStack(alignment: .center) {
                            AudioInputMessageView(audioUrl: $viewModel.audioUrl,
                                                  showAudioView: $showAudioView,
                                                  blockAudioRecord: $blockAudioRecord,
                                                  textDragPadding: $textDragPadding,
                                                  blockDragPadding: $blockDragPadding,
                                                  resetAudio: $resetAudio)
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
                            viewModel.sources.plus
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
                                } else if quickActionCurrentUser == .edit {
                                    viewModel.send(.onEdit(viewModel.inputText, activeEditMessage?.eventId ?? ""))
                                    viewModel.inputText = ""
                                    activeEditMessage = nil
                                    quickActionCurrentUser = nil
                                    viewModel.send(.onSendText(viewModel.inputText))
                                } else {
                                    viewModel.send(.onSendText(viewModel.inputText))
                                }
                            }
                        }, label: {
                            viewModel.sources.paperPlane
                                .foreground(.blue())
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 16)
                    } else {
                        MicrophoneMessageView(showAudioView: $showAudioView,
                                              blockDragPadding: $blockDragPadding,
                                              blockAudioRecord: $blockAudioRecord,
                                              textDragPadding: $textDragPadding,
                                              resetAudio: $resetAudio,
                                              record: $record)
                        .frame(width: 24,
                               height: 24)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .frame(height: min((quickActionCurrentUser == .edit ? 68 : (quickAction == .reply ? 68 : 18)) + textViewHeight, 160) )
            .background(.white())
            .ignoresSafeArea()

            Rectangle()
                .fill(Color(.white()))
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
                    viewModel.sources.backButton
                })
                AsyncImage(
                    url: viewModel.room.roomAvatar,
                    placeholder: {
                        ZStack {
                            Color(.lightBlue())
                            Text(viewModel.room.summary.displayname?.firstLetter.uppercased() ?? "?")
                                .foreground(.white())
                                .font(.medium(20))
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
                .alert(isPresented: $showJoinAlert) {
                    let roomName = viewModel.room.summary.displayname ??  viewModel.sources.chatNewRequest
                    return Alert(
                        title: Text(viewModel.sources.joinChat),
                        message: Text("\(viewModel.sources.acceptTheInvitation) \(roomName)"),
                        primaryButton: .default(
                            Text(viewModel.sources.join),
                            action: {
                                viewModel.send(.onJoinRoom)
                            }
                        ),
                        secondaryButton: .cancel(
                            Text(viewModel.sources.callListAlertActionOne),
                            action: { presentationMode.wrappedValue.dismiss() }
                        )
                    )
                }
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(viewModel.room.summary.displayname ?? "")
                            .lineLimit(1)
                            .font(.semibold(15))
                            .foreground(.black())
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        if viewModel.room.isDirect {
                            Text(viewModel.room.isOnline ?  viewModel.sources.chatOnline :
                                    viewModel.sources.chatOffline)
                            .lineLimit(1)
                            .font(.regular(13))
                            .foreground(viewModel.room.isOnline ? .blue() : .black(0.5))
                        } else {
                            Text("Участники (\(viewModel.chatData.contacts.count.description))")
                                .lineLimit(1)
                                .font(.regular(13))
                                .foreground(.black(0.5))
                        }
                        Spacer()
                    }
                }
                .alert(isPresented: $showTranslateAlert) {
                    let dismissButton = Alert.Button.default(Text(viewModel.sources.translateChange)) {
                        translateCardPosition = .custom(UIScreen.main.bounds.height - 630)
                    }
                    let confirmButton = Alert.Button.default(Text(viewModel.sources.translate)) {
                        for message in viewModel.messages {
                            viewModel.translateTo(languageCode: "ru", message: message)
                        }
                    }
                    return Alert(title: Text(viewModel.sources.translateIntoRussian),
                                 message: Text(viewModel.sources.translateAlertEncryption),
                                 primaryButton: confirmButton, secondaryButton: dismissButton)
                }
                .frame(width: 160)
                
                Spacer()
            }
            .background(.white())
            .onTapGesture {
                viewModel.send(.onSettings(chatData: $viewModel.chatData,
                                           saveData: $viewModel.saveData,
                                           room: viewModel.room))
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 8) {
                if viewModel.isVideoCallAvailable {
                    Button(action: {
                        viewModel.p2pVideoCallPublisher.send()
                    }, label: {
                        viewModel.sources.videoFill.tint(.black)
                    }).disabled(!$viewModel.isVideoCallAvailablility.wrappedValue)
                }
                if viewModel.isVoiceCallAvailable {
                    Button(action: {
                        viewModel.p2pVoiceCallPublisher.send()
                    }, label: {
                        viewModel.sources.phoneFill.tint(.black)
                    }).disabled(!$viewModel.isVoiceCallAvailablility.wrappedValue)
                }
				if viewModel.isGroupCall {
					Button(action: {
						viewModel.groupCallPublisher.send()
					}, label: {
						viewModel.sources.videoFill.tint(.black)
					})
				}
                if viewModel.getMenuStatus() {
                    Button(action: {
                        hideKeyboard()
                        cardGroupPosition = .custom(180)
                    }, label: {
                        viewModel.sources.settingsButton
                    })
                    .padding(.trailing, 6)
                }
            }
        }
    }
}
