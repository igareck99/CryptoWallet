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
        UITextView.appearance().background(.aliceBlue)
    }

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
            }
            .hideKeyboardOnTap()
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(.white, isBlured: false)
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
                    Text(viewModel.resources.settings)
                        .font(.subheadlineMedium15)
                        .foregroundColor(viewModel.resources.titleColor)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
						chatData.title = titleText
						chatData.description = descriptionText
                        saveData = true
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text(viewModel.resources.profileDetailRightButton)
                            .font(.subheadlineMedium15)
                            .foregroundColor(viewModel.resources.buttonBackground)
                    })
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImage: $chatData.image)
            }
            .alert(isPresented: $showLeaveAlert, content: {
                Alert(title: Text(SettingsAction.exit.title),
                      message: Text(SettingsAction.exit.message),
                      primaryButton: .default(Text(viewModel.resources.profileDetailLogoutAlertTitle)),
                      secondaryButton: .default(Text(viewModel.resources.profileDetailLogoutAlertApprove)) { viewModel.send(.onLeave) })
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
                viewModel.resources.textBoxBackground
                    .frame(width: size.width, height: size.width)
            }

            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewModel.send(.onImagePicker($chatData.image))
                        } label: {
                            Image(systemName: "camera")
                                .resizable()
                                .renderingMode(.template)
                                .tint(viewModel.resources.background)
                                .frame(width: 26, height: 21.27)
                                .scaledToFill()
                        }
                        .background(
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(viewModel.resources.backgroundFodding)
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
                .background(viewModel.resources.textBoxBackground)
                .padding(.horizontal, 16)

            if titleText.isEmpty {
                HStack(spacing: 0) {
                    Text(viewModel.resources.createChannelTitle)
                        .foregroundColor(viewModel.resources.textColor)
                        .padding(.horizontal, 16)
                        .disabled(true)
                        .allowsHitTesting(false)
                    Spacer()
                }.frame(height: 44)
            }
        }
        .frame(height: 44)
        .background(viewModel.resources.textBoxBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var infoView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(viewModel.resources.contactChatDetailInfo.uppercased())
                    .font(.caption1Medium12)
                    .foregroundColor(viewModel.resources.textColor)
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
                        Text(viewModel.resources.createChannelDescription)
                            .foregroundColor(viewModel.resources.textColor)
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
            .background(viewModel.resources.textBoxBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Divider()
                .foregroundColor(viewModel.resources.dividerColor)
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
                        R.image.registration.arrow.image
                    case .media:
                        Text(chatData.media.count.description, [
                            .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                        ]).font(.subheadlineRegular15)
                            .foregroundColor(viewModel.resources.buttonBackground)
                            .frame(height: 64)
                            .padding(.leading, 16)

                        R.image.chatSettings.chevron.image
                            .padding(.leading, 4)
                    case .admins:
                        Text(chatData.admins.count.description, [
                            .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                        ]).font(.subheadlineRegular15)
                            .foregroundColor(viewModel.resources.buttonBackground)
                            .frame(height: 64)
                            .padding(.leading, 16)

                        R.image.chatSettings.chevron.image
                            .padding(.leading, 4)
                    default:
                        Spacer()
                    }
                }
                .frame(height: 64)
                .background(viewModel.resources.background)
                .onTapGesture {
                    switch action {
                    case .notifications:
                        viewModel.send(.onNotifications)
                    case .media:
                        vibrate()
                        viewModel.send(.onMedia)
                    case .admins:
                        vibrate()
                        viewModel.send(.onAdmin($chatData))
                    default:
                        ()
                    }
                }
            }

            Divider()
                .foregroundColor(viewModel.resources.dividerColor)
                .padding(.top, 16)
        }
    }

    private var sectionView: some View {
        HStack(spacing: 0) {
            Text(viewModel.resources.channelInfoParticipant.uppercased(), [
                .paragraph(.init(lineHeightMultiple: 1.54, alignment: .left))
            ]).font(.caption1Medium12)
                .foregroundColor(viewModel.resources.textColor)
            Spacer()

            if !chatData.isDirect {
                Button {
                    viewModel.send(.onMembers($chatData))
                } label: {
                    Text(viewModel.resources.channelInfoOpen.uppercased(), [
                        .paragraph(.init(lineHeightMultiple: 1.54, alignment: .right))
                    ]).font(.caption1Medium12)
                        .foregroundColor(viewModel.resources.buttonBackground)
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
                // TODO: - Обработать логику View
                contact.view()
//                .onTapGesture {
//                    viewModel.send(.onFriendProfile(contact: contact))
//                }
                    .background(viewModel.resources.background)
//                    .swipeActions(edge: .trailing) {
//                        Button {
//                            chatData.contacts.removeAll { $0.id == contact.id }
//                        } label: {
//                            R.image.chat.reaction.delete.image
//                                .renderingMode(.original)
//                                .foreground(viewModel.resources.buttonBackground)
//                        }
//                        .tint(viewModel.resources.negativeTintColor)
//                    }
            }

            Divider()
                .foregroundColor(viewModel.resources.dividerColor)
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
