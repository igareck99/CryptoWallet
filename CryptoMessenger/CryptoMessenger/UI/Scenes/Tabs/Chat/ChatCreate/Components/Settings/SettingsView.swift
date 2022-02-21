import SwiftUI

// MARK: - SettingsAction

enum SettingsAction: CaseIterable, Identifiable {

    // MARK: - Types

    case media, notifications, admins
    case share, exit, complain

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var image: Image {
        switch self {
        case .media:
            return R.image.chatSettings.media.image
        case .notifications:
            return R.image.chatSettings.notifications.image
        case .admins:
            return R.image.chatSettings.admins.image
        case .share:
            return R.image.chatSettings.share.image
        case .exit:
            return R.image.chatSettings.exit.image
        case .complain:
            return R.image.chatSettings.complain.image
        }
    }

    var title: String {
        switch self {
        case .media:
            return "Медиа, ссылки и документы"
        case .notifications:
            return "Уведомления"
        case .admins:
            return "Администраторы"
        case .share:
            return "Поделиться чатом"
        case .exit:
            return "Выйти из чата"
        case .complain:
            return "Пожаловаться на сообщение"
        }
    }

    var color: Palette {
        switch self {
        case .exit, .complain:
            return .red(0.1)
        default:
            return .blue(0.1)
        }
    }

    var view: some View {
        HStack(spacing: 0) {
            HStack { image }
            .frame(width: 40, height: 40)
            .background(color)
            .cornerRadius(20)
            .padding([.top, .bottom], 12)

            Text(title, [
                .color(.black()),
                .font(.regular(15)),
                .paragraph(.init(lineHeightMultiple: 1.09, alignment: .left))
            ])
                .frame(height: 64)
                .padding(.leading, 16)

            Spacer()
        }
        .frame(height: 64)
        .background(.white())
    }

    var alertItem: AlertItem? {
        switch self {
        case .exit:
            return .init(
                title: Text("Выйти из чата"),
                message: Text("Вы действительно хотите выйти из чата?"),
                primaryButton: .default(Text("Отменить")),
                secondaryButton: .default(Text("Выйти"))
            )
        case .complain:
            return .init(
                title: Text("Пожаловаться на чат"),
                message: Text("Вы действительно хотите пожаловаться чат?"),
                primaryButton: .default(Text("Отменить")),
                secondaryButton: .default(Text("Хочу"))
            )
        default:
            return nil
        }
    }
}

// MARK: - AlertItem

struct AlertItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var title: Text
    var message: Text?
    var primaryButton: Alert.Button
    var secondaryButton: Alert.Button
}

// MARK: - SettingsView

struct SettingsView: View {

    // MARK: - Internal Properties

    @Binding var chatData: ChatData

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
    @State private var topActions: [SettingsAction] = [.media, .notifications, .admins]
    @State private var bottomActions: [SettingsAction] = [.share, .exit, .complain]
    @State private var alertItem: AlertItem?
    @Injectable private var mxStore: MatrixStore

    // MARK: - Life Cycle

    init(chatData: Binding<ChatData>) {
        self._chatData = chatData
        UITextView.appearance().background(.paleBlue())
    }

    // MARK: - Body

    var body: some View {
        content
            .hideKeyboardOnTap()
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(.white(), isBlured: false)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
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
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(.blue())
                    })
                }
            }
            .overlay(
                EmptyNavigationLink(
                    destination: SelectContactView(mode: .add, chatData: $chatData),
                    isActive: $showContacts
                )
            )
            .overlay(
                EmptyNavigationLink(
                    destination: ContentView(chatData: $chatData),
                    isActive: $showContent
                )
            )
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImage: $chatData.image)
            }
            .alert(item: $alertItem) { alert in
                Alert(
                    title: alert.title,
                    message: alert.message,
                    primaryButton: alert.primaryButton,
                    secondaryButton: alert.secondaryButton
                )
            }
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
            TextField("", text: $chatData.title)
                .frame(height: 44)
                .background(.paleBlue())
                .padding(.horizontal, 16)

            if chatData.title.isEmpty {
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
                TextEditor(text: $chatData.description)
                    .padding(.horizontal, 14)
                    .padding(.top, 6)

                if chatData.description.isEmpty {
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
            ForEach(topActions) { action in
                HStack(spacing: 0) {
                    action.view

                    Spacer()

                    if action == .notifications {
                        Toggle("", isOn: $notificationsTurnedOn)
                            .tint(Color(.blue()))
                    } else {
                        Text(chatData.media.count.description, [
                            .color(.blue()),
                            .font(.regular(15)),
                            .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                        ])
                            .frame(height: 64)
                            .padding(.leading, 16)

                        R.image.chatSettings.chevron.image
                            .padding(.leading, 4)
                    }
                }
                .frame(height: 64)
                .background(.white())
                .onTapGesture {
                    switch action {
                    case .media:
                        guard !chatData.media.isEmpty else { return }
                        vibrate()
                        showContent.toggle()
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
                    Text("ДОБАВИТЬ", [
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
        List {
            ForEach(chatData.contacts) { contact in
                ContactRow(
                    avatar: contact.avatar,
                    name: contact.name,
                    status: contact.status,
                    hideSeparator: contact.id == chatData.contacts.last?.id
                )
                    .background(.white())
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .id(contact.id)
                    .swipeActions(edge: .trailing) {
                        Button {
                            //viewModel.send(.onDeleteRoom(room.room.roomId))
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
        .listStyle(.plain)
        .frame(height: 64 * CGFloat(chatData.contacts.count) > 0 ? 64 * CGFloat(chatData.contacts.count) + CGFloat(16): 0)
    }

    private var bottomActionsView: some View {
        VStack(spacing: 0) {
            ForEach(bottomActions) { action in
                action.view
                    .onTapGesture {
                        if let alert = action.alertItem {
                            vibrate()
                            alertItem = alert
                        }
                    }
            }
        }
    }
}
