import SwiftUI

// swiftlint: disable: all

// MARK: - ChannelInfoView

struct ChannelInfoView<ViewModel: ChannelInfoViewModelProtocol>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var showNotificationsView = false
    @State private var showParticipantsView = false
    @State private var showAddUser = false
    @State var textViewHeight: CGFloat = 120
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var showActionImageAlert = false
    @State private var showSettingsAlert = false
    @State private var selectedRole: ChannelRole?
    let resources: ChannelInfoResourcable.Type

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.changeViewEdit {
                changeView
            } else {
                mainView
            }
        }
        .onAppear {
            viewModel.setData()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .toolbar {
            if viewModel.changeViewEdit {
                createChangeToolBar()
            } else {
                createToolBar()
            }
        }
        .sheet(isPresented: $viewModel.showChannelChangeType, content: {
            NavigationView {
                SelectChannelTypeView(
                    viewModel: SelectChannelTypeViewModel(roomId: viewModel.room.roomId),
                    showChannelChangeType: $viewModel.showChannelChangeType
                ) { value in
                    switch value {
                    case .publicChannel:
                        viewModel.isRoomPublicValue = true
                    case .privateChannel:
                        viewModel.isRoomPublicValue = false
                    default:
                        break
                    }
                }
            }
        })
        .sheet(isPresented: $showAddUser, content: {
            NavigationView {
                ChannelAddUserView(viewModel: SelectContactViewModel(mode: .add, onUsersSelected: {
                    selectedContacts in
                    viewModel.onInviteUsersToChannel(users: selectedContacts)
                }))
            }
        })
        .sheet(isPresented: $viewModel.showSelectOwner, content: {
            NavigationView {
                ChannelNewOwnerView(users: viewModel.getChannelUsers().filter({
                    viewModel.getUserRole($0.matrixId) != .owner
                })) { selectedContacts in
                    viewModel.onAssignNewOwners(users: selectedContacts) {
                    }
                }
            }
        })
        .sheet(isPresented: $viewModel.showSelectCurrentUserRole, content: {
            NavigationView {
                ChannelNewOwnerView(users: viewModel.getChannelUsers().filter({
                    viewModel.getUserRole($0.matrixId) != .owner
                })) { selectedContacts in
                    viewModel.onAssignAnotherOwners(users: selectedContacts,
                                                    newRole: selectedRole) {
                    }
                }
            }
        })
        .sheet(isPresented: $viewModel.showUserSettings, content: {
            UserSettingsAssembly.build(userId: $viewModel.tappedUserId,
                                       showBottomSheet: $viewModel.showChangeRole,
                                       showUserProfile: $viewModel.showUserProfile,
                                       roomId: viewModel.room.roomId,
                                       roleCompare: viewModel.compareRoles()) {
                viewModel.showUserSettings = false
                viewModel.onUserRemoved()
            } onUserProfile: {
                viewModel.showUserSettings = false
                viewModel.dismissSheet()
            }
            .presentationDetents([.height(computeSizeOfUserMenu(viewModel.compareRoles()))])
        })
        .customConfirmDialog(
            isPresented: $viewModel.showMakeRole,
            actionsAlignment: .center,
            actions: {
                TextActionViewModel
                    .MakeRole
                    .actions($viewModel.showMakeRole) {
                        viewModel.onMakeRoleTap()
                    }
            }, cancelActions: {
                TextActionViewModel
                    .MakeRole
                    .cancelActions($viewModel.showMakeRole)
            })
        .customConfirmDialog(
            isPresented: $viewModel.showMakeNewRole,
            actionsAlignment: .center,
            actions: {
                TextActionViewModel
                    .MakeNewRole
                    .actions($viewModel.showMakeNewRole) {
                        if !showParticipantsView {
                            viewModel.onMakeCurrentUserRoleTap()
                        }
                    }
            }, cancelActions: {
                TextActionViewModel
                    .MakeNewRole
                    .cancelActions($viewModel.showMakeNewRole)
            })
        .customConfirmDialog(
            isPresented: $viewModel.showChangeRole,
            actionsAlignment: .center,
            actions: {
                TextActionViewModel
                    .SelectRole
                    .actions($viewModel.showChangeRole,
                             viewModel.getCurrentUserRole()) {
                        selectedRole = $0
                        viewModel.onRoleSelected(role: $0, ownerCheck: true)
                    }
            }, cancelActions: {
                TextActionViewModel
                    .SelectRole
                    .cancelActions($viewModel.showChangeRole)
            })
        .customConfirmDialog(
            isPresented: $viewModel.showDeleteChannel,
            actionsAlignment: .center,
            actions: {
                TextActionViewModel
                    .DeleteChannel
                    .actions($viewModel.showDeleteChannel) {
                        viewModel.showLeaveChannel = true
                    } onDeleteAllUsers: {
                        viewModel.onDeleteAllUsers()
                    }
                
            }, cancelActions: {
                TextActionViewModel
                    .DeleteChannel
                    .cancelActions($viewModel.showDeleteChannel)
            })
        .customConfirmDialog(
            isPresented: $viewModel.showLeaveChannel,
            actionsAlignment: .center,
            actions: {
                TextActionViewModel
                    .LeaveChannel
                    .actions($viewModel.showLeaveChannel,
                             viewModel.isRoomPublicValue) {
                        viewModel.onLeaveChannel()
                    }
            }, cancelActions: {
                TextActionViewModel
                    .LeaveChannel
                    .cancelActions($viewModel.showLeaveChannel)
            })
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: resources.linkCopied,
                color: viewModel.resources.snackbarBackground
            )
        }
        .onAppear {
            UITextView.appearance()
        }.background(viewModel.resources.background)
    }

    private var mainView: some View {
        List {
            Section {
                screenHeaderView()
                    .frame(maxWidth: .infinity)
                    .listRowInsets(.none)
                    .listRowBackground(Color.clear)
            }
            if viewModel.shouldShowDescription {
                Section {
                    channelDescriptionView()
                }
                
            }
            Section {
                attachmentsView()
                notificationsView()
            }
            if viewModel.isAuthorized {
                Section {
                    VStack(alignment: .leading) {
                        participantsHeader()
                            .listRowSeparator(.hidden)
                        channelParticipantsView()
                        participantsFooter()
                            .listRowSeparator(.hidden)
                            .frame(maxWidth: .infinity)
                            .listRowInsets(.none)
                            .padding(.top, 6)
                    }
                }
            }
            Section {
                copyLinkView()
                leaveChannelView()
            }
        }
        .listStyle(.insetGrouped)
    }

    private var changeView: some View {
        List {
            changeGroupInfoView
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            if viewModel.isChannel {
                Section {
                    changeChannelTypeView()
                    if viewModel.getCurrentUserRole() == .owner {
                        deleteChannelView()
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Private Methods
    
    private func changeAvatarView() -> some View {
        VStack(alignment: .center, spacing: 10) {
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
                                Color.diamond
                                Text(viewModel.roomDisplayName.firstLetter)
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
            }
            Text("Изменить фотографию")
                .font(.semibold(17))
                .foregroundColor(.dodgerBlue)
                .onTapGesture {
                    showActionImageAlert = true
                }
        }
        .actionSheet(isPresented: $showActionImageAlert) {
            ActionSheet(title: Text(""),
                        message: nil,
                        buttons: [
                            .cancel(),
                            .default(
                                Text(viewModel.resources.profileFromGallery).font(.bodyRegular17),
                                action: {
                                    viewModel.selectPhoto(.photoLibrary)
                                }
                            ),
                            .default(
                                Text(viewModel.resources.profileFromCamera).font(.bodyRegular17),
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
            Button("Настройки") {
                debugPrint("Settings buttob tap")
                viewModel.onOpenSettingsTap()
            }
        }
    }

    private var changeGroupInfoView: some View {
        VStack(spacing: 10) {
            changeAvatarView()
            TextFieldView(
                title: "",
                text: $viewModel.roomDisplayName,
                placeholder: "",
                color: viewModel.resources.background
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(viewModel.resources.background)
            )
            .padding(.top, 24)
            TextEditor(text: $viewModel.channelTopic)
                .placeholder("Описание", when: viewModel.channelTopic.isEmpty, alignment: .topLeading)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                .background(viewModel.resources.background)
                .foregroundColor(viewModel.resources.titleColor)
                .font(.bodyRegular17)
                .frame(height: 134)
                .cornerRadius(8)
        }
    }

    private func screenHeaderView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
                .frame(height: 1)
            if let img = viewModel.selectedImg {
                Image(uiImage: img)
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
                    .padding(.bottom, 16)
            } else {
                AsyncImage(
                    defaultUrl: viewModel.roomImageUrl,
                    placeholder: {
                        ZStack {
                            Color.dodgerTransBlue
                            Text(viewModel.roomDisplayName)
                                .foregroundColor(viewModel.resources.background)
                                .font(.title2Regular22)
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(40)
                .padding(.bottom, 16)
            }
            Text(viewModel.roomDisplayName)
                .font(.system(size: 22))
                .foregroundColor(viewModel.resources.titleColor)
                .padding(.bottom, 4)
            Text("\(viewModel.getChannelUsers().count) \(resources.participant)")
                .font(.subheadlineRegular15)
                .foregroundColor(viewModel.resources.textColor)
        }
    }
    
    private func channelDescriptionView() -> some View {
        ZStack {
            TextEditor(text: .constant(viewModel.channelTopic))
                .background(viewModel.resources.background)
                .foregroundColor(viewModel.resources.titleColor)
                .font(.system(size: 17))
                .cornerRadius(8)
            Text(viewModel.channelTopic).opacity(0).padding([.leading, .trailing, .top], 8)
        }
    }
    
    private func attachmentsView() -> some View {
        ChannelSettingsView(
            title: resources.attachments,
            imageName: "folder",
            accessoryImageName: "chevron.right"
        )
        .onTapGesture {
            viewModel.nextScene(.onMedia(viewModel.room.roomId))
        }
    }

    private func notificationsView() -> some View {
        ChannelSettingsView(
            title: resources.notifications,
            imageName: "bell",
            accessoryImageName: "chevron.right"
        )
        .onTapGesture {
            viewModel.showNotifications()
        }
    }

    private func copyLinkView() -> some View {
        ChannelSettingsView(
            title: resources.copyLink,
            imageName: "doc.on.doc",
            accessoryImageName: ""
        )
        .onTapGesture {
            UIPasteboard.general.string = viewModel.room.roomId
            viewModel.onChannelLinkCopy()
        }
    }

    private func leaveChannelView() -> some View {
        ChannelSettingsView(
            title: viewModel.leaveChannelText,
            titleColor: .amaranthApprox,
            imageName: "rectangle.portrait.and.arrow.right",
            imageColor: viewModel.resources.negativeColor,
            accessoryImageName: ""
        )
        .onTapGesture {
            viewModel.showLeaveChannel = true
        }
    }

    private func changeChannelTypeView() -> some View {
        ChannelSettingsView(
            title: resources.channelType,
            imageName: "megaphone",
            accessoryImageName: "",
            value: viewModel.isRoomPublicValue ? resources.publicChannel :
                resources.privateChannel
        )
        .onTapGesture {
            if viewModel.getCurrentUserRole() == .owner {
                viewModel.showChannelChangeType = true
            }
        }
    }

    private func deleteChannelView() -> some View {
        ChannelSettingsView(
            title: resources.deleteChannel,
            titleColor: viewModel.resources.negativeColor,
            imageName: "trash",
            imageColor: viewModel.resources.negativeColor,
            accessoryImageName: ""
        )
        .onTapGesture {
            viewModel.showDeleteChannel = true
        }
    }

    private func participantsHeader() -> some View {
        HStack {
            Text(resources.participants)
                .font(.bodySemibold17)
                .foregroundColor(viewModel.resources.titleColor)
            Spacer()
            Text(resources.add)
                .font(.bodyRegular17)
                .foregroundColor(viewModel.resources.buttonBackground)
                .onTapGesture {
                    showAddUser = true
                }
        }
    }

    @ViewBuilder
    private func channelParticipantsView() -> some View {
        ForEach(viewModel.getChannelUsers(), id: \.self) { item in
            if viewModel.getChannelUsers().firstIndex(of: item) ?? 2 < 2 {
                VStack {
                    ChannelParticipantView(
                        title: item.name,
                        subtitle: viewModel.isChannel ? item.role.text : item.matrixId
                    )
                    .background(.white)
                    .frame(height: 64)
                    .onTapGesture {
                        viewModel.tappedUserId = item.matrixId
                        viewModel.showUserSettings = true
                    }
                }
                Divider()
                    .padding(.leading, 52)
            }
        }
    }

    private func participantsFooter() -> some View {
        return Text("\(resources.lookAll) ( \(viewModel.getChannelUsers().count) \(resources.participant) )")
            .font(.bodySemibold17)
            .foregroundColor(viewModel.resources.textBoxBackground)
            .onTapGesture {
                viewModel.showParticipantsView(viewModel as! ChannelInfoViewModel,
                                               $showParticipantsView)
            }
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        if viewModel.isAuthorized {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    changeScreen(isEdit: true)
                }, label: {
                    Text(resources.change)
                        .font(.bodyRegular17)
                        .foregroundColor(viewModel.resources.textBoxBackground)
                })
            }
        }
    }

    @ToolbarContentBuilder
    private func createChangeToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                withAnimation(.linear(duration: 0.5)) {
                    viewModel.shouldChange = false
                    changeScreen(isEdit: false)
                }
            }, label: {
                Text(resources.presentationCancel)
                    .font(.bodyRegular17)
                    .foregroundColor(viewModel.resources.textBoxBackground)
            })
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.shouldChange = true
                changeScreen(isEdit: false)
            }, label: {
                Text("Сохранить")
                    .font(.regular(17))
                    .foregroundColor(viewModel.resources.textBoxBackground)
            })
        }
    }
    
    private func computeSizeOfUserMenu(_ value: ChannelUserActions) -> CGFloat {
        if value.delete && value.changeRole {
            return CGFloat(223)
        } else if value.delete || value.changeRole {
            return CGFloat(183)
        } else {
            return CGFloat(109)
        }
    }

    private func changeScreen(isEdit: Bool) {
        withAnimation(.linear(duration: 0.35)) {
            viewModel.changeViewEdit = isEdit
        }
    }
}
