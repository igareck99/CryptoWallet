import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: SettingsViewModel
    @Binding var isLeaveRoom: Bool
    @Binding var chatData: ChatData
    @Binding var saveData: Bool
	@State var descriptionText: String
	@State var titleText: String

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var showImagePicker = false
    @State private var showContent = false
    @State private var showAdmins = false
    @State private var showContacts = false
    @State private var showExitAlert = false
    @State private var showShareAlert = false
    @State private var showComplainAlert = false
    @State private var notificationsTurnedOn = false
    @State private var isNotifications = false
    @State private var alertItem: AlertItem?
    @State private var showLeaveAlert = false

    // MARK: - Life Cycle

    init(isLeaveRoom: Binding<Bool>, chatData: Binding<ChatData>,
         saveData: Binding<Bool>, viewModel: SettingsViewModel) {
        self._isLeaveRoom = isLeaveRoom
        self._chatData = chatData
        self._saveData = saveData
        self._viewModel = StateObject(wrappedValue: viewModel)
		_descriptionText = State(initialValue: chatData.wrappedValue.description)
		_titleText = State(initialValue: chatData.wrappedValue.title)
        UITextView.appearance().background(.paleBlue())
    }

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                isNotifications = viewModel.isEnabled
                viewModel.send(.onAppear)
            }
            .hideKeyboardOnTap()
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(.white(), isBlured: false)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        saveData = false
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        R.image.navigation.backButton.image
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text("Настройки")
                        .font(.bold(15))
                        .foreground(.black())
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
						chatData.title = titleText
						chatData.description = descriptionText
                        saveData = true
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(.blue())
                    })
                }
            }
            .onChange(of: viewModel.isLeaveRoom, perform: { value in
                if value {
                    self.isLeaveRoom = true
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .overlay(
                EmptyNavigationLink(
                    destination: MembersView(chatData: $chatData),
                    isActive: $showContacts
                )
            )
            .overlay(
                EmptyNavigationLink(
                    destination: AdminsView(chatData: $chatData),
                    isActive: $showAdmins
                )
            )
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImage: $chatData.image)
            }
            .alert(isPresented: $showLeaveAlert, content: {
                Alert(title: Text(SettingsAction.exit.title),
                      message: Text(SettingsAction.exit.message),
                      primaryButton: .default(Text("Отменить")),
                      secondaryButton: .default(Text("Выйти")) { viewModel.send(.onLeave) })
            })
    }

    // MARK: - Body Properties

    private var content: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    imageView(geometry.size)
                        .frame(width: geometry.size.width, height: geometry.size.width)

                    titleView
                        .padding(.horizontal, 16)
                        .padding(.top, 24)

                    infoView
                        .padding(.horizontal, 16)
                        .padding(.top, 24)

                    topActionsView
                        .padding(.top, 16)
                        .padding(.horizontal, 16)

                    sectionView
                        .padding(.top, 24)
                        .padding(.horizontal, 16)

                    contactsView

                    bottomActionsView
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 50)
                }
            }
        }
    }

    private func imageView(_ size: CGSize) -> some View {
        ZStack {
            if let image = chatData.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.width)
                    .clipped()
            } else {
                Color(.paleBlue())
                    .frame(width: size.width, height: size.width)
            }

            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showImagePicker.toggle()
                        } label: {
                            Image(systemName: "camera")
                                .resizable()
                                .renderingMode(.template)
                                .tint(.white)
                                .frame(width: 26, height: 21.27)
                                .scaledToFill()
                        }
                        .background(
                            Circle()
                                .frame(width: 60, height: 60)
                                .foreground(.black(0.4))
                        )
                        .frame(width: 60, height: 60)
                        .padding([.trailing, .bottom], 16)
                    }
                }
            }
        }
    }

    private var titleView: some View {
        ZStack {
            TextField("", text: $titleText)
                .frame(height: 44)
                .background(.paleBlue())
                .padding(.horizontal, 16)

            if titleText.isEmpty {
                HStack(spacing: 0) {
                    Text("Название")
                        .foreground(.darkGray())
                        .padding(.horizontal, 16)
                        .disabled(true)
                        .allowsHitTesting(false)
                    Spacer()
                }.frame(height: 44)
            }
        }
        .frame(height: 44)
        .background(.paleBlue())
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var infoView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Информация".uppercased())
                    .font(.semibold(12))
                    .foreground(.darkGray())
                Spacer()
            }
            .frame(height: 22)
            .padding(.top, 24)
            .padding(.bottom, 8)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $descriptionText)
                    .padding(.horizontal, 14)
                    .padding(.top, 6)
					.scrollContentBackground(.hidden)

                if descriptionText.isEmpty {
                    HStack(spacing: 0) {
                        Text("Описание")
                            .foreground(.darkGray())
                            .disabled(true)
                            .allowsHitTesting(false)
                        Spacer()
                    }
                    .frame(height: 20)
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                }
            }
            .frame(height: 132)
            .background(.paleBlue())
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Divider()
                .foreground(.grayE6EAED())
                .padding(.top, 24)
        }
    }

    private var topActionsView: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.topActions) { action in
                HStack(spacing: 0) {
                    action.view

                    Spacer()

                    switch action {
                    case .notifications:
                        let notificationsBinding = Binding<Bool>(
                            get: { self.isNotifications },
                            set: { self.isNotifications = $0
                                viewModel.changeNotificationState($0)
                            }
                        )
                        Toggle("", isOn: notificationsBinding)
                            .tint(Color(.blue()))
                    case .media:
                        Text(chatData.media.count.description, [
                            .color(.blue()),
                            .font(.regular(15)),
                            .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                        ])
                            .frame(height: 64)
                            .padding(.leading, 16)

                        R.image.chatSettings.chevron.image
                            .padding(.leading, 4)
                    case .admins:
                        Text(chatData.admins.count.description, [
                            .color(.blue()),
                            .font(.regular(15)),
                            .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                        ])
                            .frame(height: 64)
                            .padding(.leading, 16)

                        R.image.chatSettings.chevron.image
                            .padding(.leading, 4)
                    default:
                        Spacer()
                    }
                }
                .frame(height: 64)
                .background(.white())
                .onTapGesture {
                    switch action {
                    case .media:
                        guard !chatData.media.isEmpty else { return }
                        vibrate()
                        viewModel.send(.onMedia)
                    case .admins:
                        vibrate()
                        showAdmins.toggle()
                    default:
                        ()
                    }
                }
            }

            Divider()
                .foreground(.grayE6EAED())
                .padding(.top, 16)
        }
    }

    private var sectionView: some View {
        HStack(spacing: 0) {
            Text("УЧАСТНИКИ", [
                .color(.darkGray()),
                .font(.semibold(12)),
                .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left))
            ])

            Spacer()

            if !chatData.isDirect {
                Button {
                    showContacts.toggle()
                } label: {
                    Text("ОТКРЫТЬ", [
                        .color(.blue()),
                        .font(.semibold(12)),
                        .paragraph(.init(lineHeightMultiple: 1.54, alignment: .right))
                    ])
                    .frame(height: 22)
                }
                .frame(height: 22)
            }
        }
        .frame(height: 22)
    }

    private var contactsView: some View {
        VStack(spacing: 0) {
            ForEach(chatData.contacts) { contact in
                ContactRow(
                    avatar: contact.avatar,
                    name: contact.name,
                    status: contact.status,
                    hideSeparator: contact.id == chatData.contacts.last?.id,
                    isAdmin: contact.isAdmin
                )
                .onTapGesture {
                    viewModel.send(.onFriendProfile(userId: contact))
                }
                    .background(.white())
                    .swipeActions(edge: .trailing) {
                        Button {
                            chatData.contacts.removeAll { $0.id == contact.id }
                        } label: {
                            R.image.chat.reaction.delete.image
                                .renderingMode(.original)
                                .foreground(.blue())
                        }
                        .tint(.red.opacity(0.1))
                    }
            }

            Divider()
                .foreground(.grayE6EAED())
                .padding(.top, 16)
        }
    }

    private var bottomActionsView: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.bottomActions) { action in
                action.view
                    .onTapGesture {
                        if let alert = action.alertItem {
                            vibrate()
                            if action == .exit {
                                showLeaveAlert.toggle()
                            }
                        }
                    }
            }
        }
    }
}
