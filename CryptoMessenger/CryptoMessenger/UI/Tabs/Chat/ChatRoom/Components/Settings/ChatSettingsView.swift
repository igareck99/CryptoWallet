import SwiftUI

// MARK: - ChatSettingsView

struct ChatSettingsView: View {
    
    @StateObject var viewModel: ChatSettingsViewModel

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var showActionImageAlert = false
    @State private var showSettingsAlert = false
    @State private var showLeaveRoom = false

    var body: some View {
        content
            .actionSheet(isPresented: $viewModel.showActionSheet) {
                switch viewModel.actionState {
                case .blockUser:
                    ActionSheet(title: Text("\(viewModel.resources.blockTitle)?"),
                                message: Text("\(viewModel.resources.blockUserDescription) Марина Антоненко?"),
                                buttons: [
                                    .cancel(),
                                    .destructive(
                                        Text(viewModel.resources.blockTitle),
                                        action: viewModel.blockUser
                                    )
                                ]
                    )
                case .leaveChat:
                    ActionSheet(title: Text("\(viewModel.resources.removeChat)?"),
                                message: Text(viewModel.resources.removeChatDescription),
                                buttons: [
                                    .cancel(),
                                    .destructive(
                                        Text(viewModel.resources.removeChat),
                                        action: viewModel.onLeaveRoom
                                    )
                                ]
                    )
                }
            }
            .toolbar {
                    createToolBar()
            }
            .navigationBarBackButtonHidden(true)
    }
    
    private var content: some View {
        List {
            screenHeaderView()
                .frame(maxWidth: .infinity)
                .listRowInsets(.none)
                .listRowBackground(Color.clear)
            Section {
                attachmentsView()
                notificationsView()
            }
            Section {
                blockUserView()
                leaveChatView()
            }
        }
    }
    
    private var encryptionView: some View {
        HStack(alignment: .center, spacing: 12) {
            R.image.chatSettings.chatSettingsLock.image
            Text("Используется сквозное шифрование")
                .font(.regular(13))
                .foreground(.romanSilver)
        }
    }
    
    // MARK: - Private Methods
    
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
    }
    
    private func screenHeaderView() -> some View {
        VStack(alignment: .center, spacing: 4) {
            Spacer()
                .frame(height: 1)
            
            if let img = viewModel.selectedImg {
                Image(uiImage: img)
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
            } else {
                AsyncImage(
                    defaultUrl: viewModel.roomImageUrl,
                    placeholder: {
                        ZStack {
                            viewModel.resources.textBoxBackground
                            Text(viewModel.roomNameLetters)
                                .foregroundColor(viewModel.resources.background)
                                .font(.system(size: 20, weight: .medium))
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(40)
            }
            Text(viewModel.roomName)
                .font(.regular(22))
                .foregroundColor(viewModel.resources.titleColor)
                .padding(.top, 6)
            Text(viewModel.roomTopic)
                .font(.regular(15))
                .foregroundColor(viewModel.resources.textColor)
            if viewModel.roomIsEncrypted {
                encryptionView
                    .padding(.top, 10)
            }
        }
    }
    
    private func attachmentsView() -> some View {
        ChannelSettingsView(
            title: viewModel.resources.attachments,
            imageName: "folder",
            accessoryImageName: "chevron.right"
        )
        .onTapGesture {
            viewModel.onMedia()
        }
    }

    private func notificationsView() -> some View {
        ChannelSettingsView(
            title: viewModel.resources.notifications,
            imageName: "bell",
            accessoryImageName: "chevron.right"
        )
        .onTapGesture {
            viewModel.onNotifications()
        }
    }
    
    private func leaveChatView() -> some View {
        ChannelSettingsView(
            title: viewModel.resources.removeChat,
            titleColor: .amaranthApprox,
            imageName: "rectangle.portrait.and.arrow.right",
            imageColor: viewModel.resources.negativeColor,
            accessoryImageName: ""
        )
        .onTapGesture {
            viewModel.showActionSheet = true
            viewModel.actionState = .leaveChat
        }
    }
    
    private func blockUserView() -> some View {
        ChannelSettingsView(
            title: viewModel.resources.blockUser,
            titleColor: .amaranthApprox,
            imageName: "",
            imageColor: viewModel.resources.negativeColor,
            accessoryImageName: "",
            image: R.image.chatSettings.blockUser.image
        )
        .onTapGesture {
            viewModel.showActionSheet = true
            viewModel.actionState = .blockUser
        }
    }
    
    private var changeGroupInfoView: some View {
        VStack(spacing: 10) {
            changeAvatarView()
            TextFieldView(
                title: "",
                text: $viewModel.roomName,
                placeholder: "",
                color: viewModel.resources.background
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(viewModel.resources.background)
            )
            TextEditor(text: $viewModel.roomTopic)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                .background(viewModel.resources.background)
                .foregroundColor(viewModel.resources.titleColor)
                .font(.system(size: 17))
                .frame(height: 134)
                .cornerRadius(8)
        }
    }
    
    private func changeAvatarView() -> some View {
        ZStack(alignment: .center) {
            if let img = viewModel.selectedImg {
                Image(uiImage: img)
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
            } else {
                AsyncImage(
                    defaultUrl: viewModel.roomImageUrl,
                    placeholder: {
                        ZStack {
                            Color.dodgerTransBlue
                            Text(viewModel.roomName)
                                .foregroundColor(viewModel.resources.background)
                                .font(.system(size: 20, weight: .medium))
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(40)
            }
            ZStack(alignment: .center) {
                Circle()
                    .foregroundColor(.dodgerBlue)
                    .frame(width: 24, height: 24)
                R.image.profileDetail.whiteCamera.image
                    .resizable()
                    .frame(width: 10.5, height: 8.2)
            }
            .padding([.top, .leading], 56)
        }
        .onTapGesture {
            showActionImageAlert = true
        }
        .actionSheet(isPresented: $showActionImageAlert) {
            ActionSheet(title: Text(""),
                        message: nil,
                        buttons: [
                            .cancel(),
                            .default(
                                Text(viewModel.resources.profileFromGallery),
                                action: {
                                    viewModel.selectPhoto(.photoLibrary)
                                }
                            ),
                            .default(
                                Text(viewModel.resources.profileFromCamera),
                                action: {
                                    let isAvailable = viewModel.onCameraPickerTap()
                                    if isAvailable {
                                        viewModel.selectPhoto(.camera)
                                    } else {
                                        showSettingsAlert = true
                                    }
                                }
                            )
                        ]
            )
        }
        .alert("Камера недоступна", isPresented: $showSettingsAlert) {
            Button("OK", role: .cancel) {
                debugPrint("Ok buttob tap")
            }
            Button {
                viewModel.onOpenSettingsTap()
            } label: {
                Text("Настройки")
            }
        }
    }
}
