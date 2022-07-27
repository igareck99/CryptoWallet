import Combine
import SwiftUI

// MARK: - ChatRoomView
// swiftlint:disable all

struct ChatRoomView: View {
    // MARK: - ActiveSheet

    enum ActiveSheet: Identifiable {

        // MARK: - Types

        case photo, documents, camera, contact

        // MARK: - Internal Properties

        var id: Int { hashValue }
    }

    // MARK: - Internal Properties

    @StateObject var viewModel: ChatRoomViewModel
    @StateObject var attachViewModel = AttachActionViewModel()
    @State var photosToSend: [UIImage] = []
    @State var sendPhotos = false
    @StateObject var attachActionViewModel = AttachActionViewModel()
    @State var showAudioView = false
    @State var record: RecordingDataModel?
    @State var blockDragPadding: CGFloat = 0
    @State private var textDragPadding: CGFloat = 0
    @State var blockAudioRecord = false
    @State var resetAudio = false

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
    
    
    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
                hideTabBar()

                switch viewModel.room.summary.membership {
                case .invite:
                    showJoinAlert = true
//                    showTranslateAlert = true
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
            }
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
            .alert(isPresented: $showJoinAlert) {
                let roomName = viewModel.room.summary.displayname ??  viewModel.sources.chatNewRequest
                return Alert(
                    title: Text(viewModel.sources.joinChat),
                    message: Text("Принять приглашение от \(roomName)"),
                    primaryButton: .default(
                        Text("Присоединиться"),
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

//            .alert(isPresented: $showTranslateAlert) { () -> Alert in
//                let dismissButton = Alert.Button.default(Text("Поменять")) {
//                    translateCardPosition = .custom(UIScreen.main.bounds.height - 630)
//                }
//                let confirmButton = Alert.Button.default(Text("Перевести")) {
//                    for message in viewModel.messages {
//                        viewModel.translateTo(languageCode: "ru", message: message)
//                    }
//                }
//                let alert = Alert(title: Text("Переводить сообщения на Русский язык"),
//                                  message: Text("ВНИМАНИЕ! При переводе сообщий их шифрования теряется!"),
//                                  primaryButton: confirmButton, secondaryButton: dismissButton)
//                return alert
//            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .photo:
                    ImagePickerView(selectedImage: $viewModel.selectedImage)
                        .navigationBarTitle(Text(viewModel.sources.photoEditorTitle))
                        .navigationBarTitleDisplayMode(.inline)
                case .documents:
                    documentPicker { urls in
                        guard !urls.isEmpty, let url = urls.first else { return }
                        self.viewModel.send(.onSendFile(url))
                    }
                case .camera:
                    SUImagePickerView(image: $viewModel.pickedImage)
                        .navigationBarTitleDisplayMode(.inline)
                case .contact:
                    NavigationView {
                        SelectContactView(contactsLimit: 1, onSelectContact: {
                            viewModel.pickedContact = $0.first
                        })
                    }
                }
            }
            .overlay(
                EmptyNavigationLink(
                    destination: SettingsView(chatData: $viewModel.chatData,
                                              saveData: $viewModel.saveData,
                                              room: viewModel.room),
                    isActive: $showSettings
                )
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(selectedPhoto != nil ? nil : .white(), isBlured: false)
            .toolbar {
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
                                    message: Text("Принять приглашение от \(roomName)"),
                                    primaryButton: .default(
                                        Text("Присоединиться"),
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
                            debugPrint("Отобразился")
                            let dismissButton = Alert.Button.default(Text("Поменять")) {
                                translateCardPosition = .custom(UIScreen.main.bounds.height - 630)
                            }
                            let confirmButton = Alert.Button.default(Text("Перевести")) {
                                for message in viewModel.messages {
                                    viewModel.translateTo(languageCode: "ru", message: message)
                                }
                            }
                            return Alert(title: Text("Переводить сообщения на Русский язык"),
                                              message: Text("ВНИМАНИЕ! При переводе сообщий их шифрования теряется!"),
                                              primaryButton: confirmButton, secondaryButton: dismissButton)
                        }
                        .frame(width: 160)

                        Spacer()
                    }
                    .background(.white())
                    .padding(.bottom, 6)
                    .onTapGesture {
                        showSettings.toggle()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {

						if viewModel.isVideoCallAvailable {
							Button(action: {
								viewModel.p2pVideoCallPublisher.send()
							}, label: {
								Image(systemName: "video.fill").tint(.black)
							}).disabled(!$viewModel.isVideoCallAvailablility.wrappedValue)
						}

						if viewModel.isVoiceCallAvailable {
							Button(action: {
								viewModel.p2pVoiceCallPublisher.send()
							}, label: {
								Image(systemName: "phone.fill").tint(.black)
							}).disabled(!$viewModel.isVoiceCallAvailablility.wrappedValue)
						}

                        Button(action: {
                            cardGroupPosition = .custom(180)
                        }, label: {
                            viewModel.sources.settingsButton
                        })
                    }
					.padding(.bottom, 8)
                }
            }
    }

    private var content: some View {
        ZStack {
            Color(.blueABC3D5()).ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollViewReader { scrollView in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            Spacer().frame(height: 16)
                            ForEach(viewModel.messages) { event in
                                if viewModel.isTranslating() {
                                    if let message = viewModel.translatedMessages.first(where: {$0.eventId == event.eventId}) {
                                        if viewModel.next(message)?.fullDate != message.fullDate {
                                            dateView(date: message.fullDate)
                                                .flippedUpsideDown()
                                                .shadow(color: Color(.lightGray()), radius: 0, x: 0, y: -0.4)
                                                .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                        }
                                        ChatRoomRow(
                                            message: message,
                                            isPreviousFromCurrentUser: viewModel.previous(message)?.isCurrentUser ?? false,
                                            isDirect: viewModel.room.isDirect,
                                            onReaction: { reactionId in
                                                vibrate()
                                                viewModel.send(
                                                    .onDeleteReaction(messageId: message.id, reactionId: reactionId)
                                                )
                                            },
                                            onSelectPhoto: { selectedPhoto = $0 }
                                        )
                                        .flippedUpsideDown()
                                        .listRowSeparator(.hidden)
                                        .onLongPressGesture(minimumDuration: 0.05, maximumDistance: 0) {
                                            vibrate(.medium)
                                            messageId = message.id
                                            activeEditMessage = message
                                            cardPosition = .custom(UIScreen.main.bounds.height - 580)
                                            hideKeyboard()
                                        }
                                    }
                                } else {
                                    if let message = viewModel.messages.first(where: {$0.eventId == event.eventId}) {
                                        if viewModel.next(message)?.fullDate != message.fullDate {
                                            dateView(date: message.fullDate)
                                                .flippedUpsideDown()
                                                .shadow(color: Color(.lightGray()), radius: 0, x: 0, y: -0.4)
                                                .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                        }
                                        ChatRoomRow(
                                            message: message,
                                            isPreviousFromCurrentUser: viewModel.previous(message)?.isCurrentUser ?? false,
                                            isDirect: viewModel.room.isDirect,
                                            onReaction: { reactionId in
                                                vibrate()
                                                viewModel.send(
                                                    .onDeleteReaction(messageId: message.id, reactionId: reactionId)
                                                )
                                            },
                                            onSelectPhoto: { selectedPhoto = $0 }
                                        )
                                        .flippedUpsideDown()
                                        .listRowSeparator(.hidden)
                                        .onLongPressGesture(minimumDuration: 0.05, maximumDistance: 0) {
                                            vibrate(.medium)
                                            messageId = message.id
                                            activeEditMessage = message
                                            cardPosition = .custom(UIScreen.main.bounds.height - 580)
                                            hideKeyboard()
                                        }
                                    }
                                }
								
                                if event.eventType == "m.room.encryption" {
                                    eventView(text: viewModel.sources.chatRoomViewEncryptedMessagesNotify)
                                        .flippedUpsideDown()
                                        .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                }
                                
                                if event.eventType == "m.room.avatar" {
                                    eventView(text: viewModel.sources.chatRoomViewSelfAvatarChangeNotify)
                                        .flippedUpsideDown()
                                        .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                }

                                if event.eventType == "m.room.member" {
                                    switch event.content["membership"] {
                                    case "join" as String:
                                        if let users = viewModel.roomUsers.filter({$0.displayname == event.content["displayname"] as? String}) {
                                            if users.contains(where: {$0.avatarUrl == event.content["avatar_url"] as? String}) {
                                                eventView(text: "\(event.content["displayname"] ?? "No name") \(viewModel.sources.chatRoomViewAvatarChangeNotify)")
                                                    .flippedUpsideDown()
                                                    .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                            } else if users.contains(where: {$0.avatarUrl == event.content["avatar_url"] as? String}) {
                                                eventView(text: "\(event.content["displayname"] ?? "No name") \(viewModel.sources.chatRoomViewRoomEntryNotify)")
                                                    .flippedUpsideDown()
                                                    .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                            }
                                        }
                                        
                                    case "leave" as String:
                                        eventView(text: "\(event.content["displayname"] ?? "No name") \(viewModel.sources.chatRoomViewLeftTheRoomNotify)")
                                            .flippedUpsideDown()
                                            .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                    case "invite" as String:
                                        eventView(text: "\(event.content["displayname"] ?? "No name") \(viewModel.sources.chatRoomViewInvitedNotify)")
                                            .flippedUpsideDown()
                                            .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                    case "unknown" as String:
                                        eventView(text: viewModel.sources.chatRoomViewUnownedErrorNotify)
                                            .flippedUpsideDown()
                                            .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                    case "ban" as String:
                                        eventView(text: "Пользователь \(event.content["displayname"] ?? "no name") \(viewModel.sources.chatRoomViewBannedNotify)")
                                            .flippedUpsideDown()
                                            .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                    default:
                                        eventView(text: "\(event.eventType)")
                                            .flippedUpsideDown()
                                            .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                    }
                                }

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
                    }
                    .flippedUpsideDown()
                }
                inputView
            }
            .animation(.easeInOut(duration: 0.3), value: keyboardHandler.keyboardHeight != 0)
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
            quickMenuView
            groupMenuView
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
    
    private func dateView(date: String) -> some View {
        HStack {
            Text(date)
                .font(.regular(14))
                .padding(.horizontal, 17)
                .padding(.vertical, 3)
        }
        .background(.lightGray())
        .cornerRadius(8)
        .padding(.vertical, 8)
    }
    
    private func eventView(text: String) -> some View {
        HStack {
            Text(text)
                .font(.regular(14))
                .padding(.horizontal, 17)
                .padding(.vertical, 3)
                .foregroundColor(.white)
        }
        .background(Color(red: 242/255, green: 160/255, blue: 76/255))
        .cornerRadius(8)
        .padding(.vertical, 8)
    }

    private var headerView: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                Spacer().frame(width: 16)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    viewModel.sources.backButton
                })

                Spacer().frame(width: 16)

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

                Spacer().frame(width: 12)

                VStack(alignment: .leading) {
                    Text(viewModel.room.summary.displayname ?? "")
                        .lineLimit(1)
                        .font(.semibold(15))
                        .foreground(.black())
                    Text(viewModel.room.isOnline ? viewModel.sources.chatOnline :
                            viewModel.sources.chatOffline)
                        .lineLimit(1)
                        .font(.regular(13))
                        .foreground(viewModel.userMessage?.status == .online ? .blue() : .black(0.5))
                }

                Spacer()
                Button(action: {

                }, label: {
                    viewModel.sources.phoneButton
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                })
                    .padding(.trailing, 12)

                Button(action: {

                }, label: {
                    viewModel.sources.settingsButton
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                })

                Spacer().frame(width: 16)
            }
            .padding(.bottom, 16)
        }
        .frame(height: 106)
        .background(.white())
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

            SlideCard(position: $cardPosition, expandedPosition: .custom(UIScreen.main.bounds.height - 580)) {
                VStack {
                    if let current = activeEditMessage?.isCurrentUser {
                        if current {
                            QuickMenuCurrentUserView(cardPosition: $cardPosition, onAction: {
                                switch $0 {
                                case .copy:
                                    UIPasteboard.general.string = activeEditMessage?.description
                                case .delete:
                                    viewModel.send(.onDelete(messageId))
                                case .edit:
                                    inputViewIsFocused = true
                                case .reply:
                                    inputViewIsFocused = true
                                default:
                                    ()
                                }
                                quickActionCurrentUser = $0
                            }).padding(.vertical, 16)
                        } else {
                            QuickMenuView(cardPosition: $cardPosition, onAction: {
                                switch $0 {
                                case .copy:
                                    UIPasteboard.general.string = activeEditMessage?.description
                                case .delete:
                                    viewModel.send(.onDelete(messageId))
                                case .reply:
                                    inputViewIsFocused = true
                                default:
                                    ()
                                }
                                quickAction = $0
                            }).padding(.vertical, 16)
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
                    GroupMenuView(action: $viewModel.groupAction, cardGroupPosition: $cardGroupPosition)
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
                            ZStack {
                                TextField("", text: $viewModel.inputText)
                                    .focused($inputViewIsFocused)
                                    .keyboardType(.default)
                                    .background(.grayDAE1E9())
                                    .foreground(.black())
                                    .padding(.horizontal, 16)
                            }
                            .background(.grayDAE1E9())
                        }
                        .frame(height: 36)
                        .background(.grayDAE1E9())
                        .clipShape(Capsule())
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
                            Image(systemName: "paperplane.fill")
                                .foreground(.blue())
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 8)
                    } else {
                        MicrophoneMessageView(showAudioView: $showAudioView,
                                              blockDragPadding: $blockDragPadding,
                                              blockAudioRecord: $blockAudioRecord,
                                              textDragPadding: $textDragPadding,
                                              resetAudio: $resetAudio,
                                              record: $record)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .frame(height: quickActionCurrentUser == .edit ? 104 : (quickAction == .reply ? 104 : 52))
            .background(.white())
            .ignoresSafeArea()

            Rectangle()
                .fill(Color(.white()))
                .frame(height: keyboardHandler.keyboardHeight == 0 ? 24 : 0)
        }
    }
}
