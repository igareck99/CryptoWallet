import Combine
import SwiftUI

// MARK: - ChatRoomView

struct ChatRoomView: View {

    // MARK: - ActiveSheet

    enum ActiveSheet: Identifiable {

        // MARK: - Types

        case photo, documents, camera, contact

        // MARK: - Internal Properties

        var id: Int { hashValue }
    }

    // MARK: - Internal Properties

    @ObservedObject var viewModel: ChatRoomViewModel

    // MARK: - Private Properties

    @StateObject private var keyboardHandler = KeyboardHandler()
    @Environment(\.presentationMode) private var presentationMode
    @State private var messageId = ""
    @State private var cardPosition: CardPosition = .bottom
    @State private var cardGroupPosition: CardPosition = .bottom
    @State private var scrolled = false
    @State private var showActionSheet = false
    @State private var showJoinAlert = false
    @State private var height = CGFloat(0)
    @State private var selectedPhoto: URL?
    @State private var showSettings = false
    @State private var showQuickMenu = false
    @State private var activeSheet: ActiveSheet?
    @State private var replyOffset: CGFloat = .zero
    @State private var showReply = false
    @State private var replyMessage: RoomMessage?

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
                hideTabBar()

                switch viewModel.room.summary.membership {
                case .invite:
                    showJoinAlert = true
                case .join:
                    viewModel.room.markAllAsRead()
                default:
                    break
                }
            }
            .onDisappear {
                showTabBar()
            }
            .onReceive(viewModel.$showPhotoLibrary) { flag in
                if flag { activeSheet = .photo }
            }
            .onReceive(viewModel.$showDocuments) { flag in
                if flag { activeSheet = .documents }
            }
            .onReceive(viewModel.$showContacts) { flag in
                if flag { activeSheet = .contact }
            }
            .alert(isPresented: $showJoinAlert) {
                let roomName = viewModel.room.summary.displayname ?? "Новый запрос"
                return Alert(
                    title: Text("Присоединиться к чату?"),
                    message: Text("Принять приглашение от \(roomName)"),
                    primaryButton: .default(
                        Text("Присоединиться"),
                        action: { viewModel.send(.onJoinRoom) }
                    ),
                    secondaryButton: .cancel(
                        Text("Отменить"),
                        action: { presentationMode.wrappedValue.dismiss() }
                    )
                )
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .photo:
                    ImagePickerView(selectedImage: $viewModel.selectedImage)
                        .ignoresSafeArea()
                        .navigationBarTitle(Text("Фото"))
                        .navigationBarTitleDisplayMode(.inline)
                case .documents:
                    documentPicker { urls in
                        guard !urls.isEmpty, let url = urls.first else { return }
                        self.viewModel.send(.onSendFile(url))
                    }
                case .camera:
                    SUImagePickerView(image: $viewModel.pickedImage)
                        .ignoresSafeArea()
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
                    destination: SettingsView(chatData: $viewModel.chatData, saveData: $viewModel.saveData),
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
                            R.image.navigation.backButton.image
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
                                    Text(viewModel.room.isOnline ? "онлайн" : "оффлайн")
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
                    HStack(spacing: 0) {
                        Spacer()
                        // Button(action: {
                        //
                        // }, label: {
                        // R.image.navigation.phoneButton.image
                        // })
                        Button(action: {
                            cardGroupPosition = .custom(482)
                        }, label: {
                            R.image.navigation.settingsButton.image
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

                            ForEach(viewModel.messages) { message in
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
                                        cardPosition = .middle
                                    }
//                                    .animation(.easeInOut(duration: 0.2))
//                                    .offset(x: replyMessage?.id == message.id ? replyOffset : .zero)
//                                    .gesture(
//                                        DragGesture().onChanged { value in
//                                            let offset = UIScreen.main.bounds.width - value.location.x - 50
//                                            guard offset < 120 else {
//                                                replyOffset = -120
//                                                return
//                                            }
//
//                                            replyOffset = -offset
//                                            if message != replyMessage {
//                                                showReply = false
//                                            }
//
//                                            replyMessage = message
//
//                                            if offset >= 110 {
//                                                if !showReply { vibrate() }
//                                                showReply = true
//                                            }
//                                        }.onEnded { _ in
//                                            replyOffset = .zero
//                                        }
//                                    )

                                if viewModel.next(message)?.fullDate != message.fullDate {
                                    dateView(date: message.fullDate)
                                        .flippedUpsideDown()
                                        .shadow(color: Color(.lightGray()), radius: 0, x: 0, y: -0.4)
                                        .shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
                                }
                            }
                            .onChange(of: viewModel.messages) { _ in
                                viewModel.room.markAllAsRead()
                                guard let id = viewModel.messages.first?.id else { return }
                                withAnimation {
                                    scrollView.scrollTo(id, anchor: .bottom)
                                }
                            }
                            .onChange(of: keyboardHandler.keyboardHeight) { _ in
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
                        .ignoresSafeArea()
                    }
                    .flippedUpsideDown()
                }

                if showReply {
                    ReplyView(
                        text: replyMessage?.description ?? "",
                        onReset: { self.replyMessage = nil; showReply = false; hideKeyboard() }
                    )
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.2))
                }

                inputView
            }
            .padding(.bottom, keyboardHandler.keyboardHeight)

            if showActionSheet {
                ActionSheetView(
                    showActionSheet: $showActionSheet,
                    attachAction: $viewModel.attachAction,
                    cameraFrame: $viewModel.cameraFrame,
                    onCamera: { showActionSheet = false; activeSheet = .camera }
                ).transition(.move(edge: .bottom).combined(with: .opacity))
            }

            quickMenuView

            groupMenuView

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
        .edgesIgnoringSafeArea(.bottom)
    }

    private func dateView(date: String) -> some View {
        HStack {
            Text(date)
                .font(.regular(14))
                .padding([.leading, .trailing], 17)
                .padding([.top, .bottom], 3)
        }
        .background(.lightGray())
        .cornerRadius(8)
        .padding([.bottom, .top], 8)
    }

    private var headerView: some View {
        VStack {
            Spacer()

            HStack(spacing: 0) {
                Spacer().frame(width: 16)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    R.image.navigation.backButton.image
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
                    Text(viewModel.room.isOnline ? "онлайн" : "оффлайн")
                        .lineLimit(1)
                        .font(.regular(13))
                        .foreground(viewModel.userMessage?.status == .online ? .blue() : .black(0.5))
                }

                Spacer()

                Button(action: {

                }, label: {
                    Image(R.image.navigation.phoneButton.name)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                })
                    .padding(.trailing, 12)

                Button(action: {

                }, label: {
                    Image(R.image.navigation.settingsButton.name)
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

            SlideCard(position: $cardPosition) {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 11) {
                            ForEach(viewModel.emojiStorage) { reaction in
                                LastReactionItemView(emoji: reaction.emoji, isLastButton: reaction.isLastButton)
                                    .onTapGesture {
                                        vibrate()
                                        viewModel.send(.onAddReaction(messageId: messageId, reactionId: reaction.id))
                                        cardPosition = .bottom
                                    }
                            }
                        }
                        .frame(height: 40)
                        .padding(.top, 22)
                        .padding(.horizontal, 16)
                    }

                    Rectangle()
                        .frame(height: 1)
                        .foreground(.darkGray(0.4))
                        .padding(.top, 12)

                    QuickMenuView(action: $viewModel.quickAction, cardPosition: $cardPosition)
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
                    GroupMenuView(action: $viewModel.groupAction, cardPosition: $cardGroupPosition)
                }.padding(.vertical, 16)
            }
        }
    }

    private var inputView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Button(action: {
                    hideKeyboard()
                    withAnimation {
                        showActionSheet.toggle()
                    }
                }, label: {
                    Image(R.image.chat.plus.name)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                    .padding(.leading, 8)

                HStack {
                    ZStack {
                        TextEditor(text: $viewModel.inputText)
                            .background(Color(.custom(#colorLiteral(red: 0.8549019608, green: 0.8823529412, blue: 0.9137254902, alpha: 1))))
                            .foreground(.black())
                            .colorMultiply(Color(.custom(#colorLiteral(red: 0.8549019608, green: 0.8823529412, blue: 0.9137254902, alpha: 1))))
                            .keyboardType(.default)
                            .padding([.leading, .trailing], 16)
                    }
                    .background(Color(.custom(#colorLiteral(red: 0.8549019608, green: 0.8823529412, blue: 0.9137254902, alpha: 1))))
                }
                .frame(height: 36)
                .background(Color(.custom(#colorLiteral(red: 0.8549019608, green: 0.8823529412, blue: 0.9137254902, alpha: 1))))
                .clipShape(Capsule())
                .padding(.trailing, viewModel.inputText.isEmpty ? 8 : 0)

                if !viewModel.inputText.isEmpty {
                    Button(action: {
                        withAnimation {
                            if let replyMessage = replyMessage {
                                viewModel.send(.onReply(viewModel.inputText, replyMessage.eventId))
                                viewModel.inputText = ""
                                self.replyMessage = nil
                                showReply = false
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
                }
            }
            .padding(.top, 8)

            Spacer()
        }
        .frame(height: keyboardHandler.keyboardHeight > 0 ? 52 : 80)
        .background(.white())
    }
}
