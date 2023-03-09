import SwiftUI

// swiftlint: disable: all

// MARK: - ChannelInfoView

struct ChannelInfoView<ViewModel: ChannelInfoViewModelProtocol>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties
    
    @Binding var isLeaveChannel: Bool
    @Environment(\.presentationMode) private var presentationMode
    @State private var showNotificationsView = false
    @State private var showParticipantsView = false
    @State private var showChannelChangeType = false
    @State private var showAddUser = false
    @State var textViewHeight: CGFloat = 120
    @State var changeViewEdit: Bool = false
    let resources: ChannelInfoResourcable.Type

    // MARK: - Body

    var body: some View {
        Group {
            if changeViewEdit {
                changeView
            } else {
                mainView
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .listStyle(.insetGrouped)
        .toolbar {
            if changeViewEdit {
                createChangeToolBar()
            } else {
                createToolBar()
            }
        }
        .sheet(isPresented: $showNotificationsView, content: {
            NavigationView {
                ChannelNotificaionsView(viewModel: ChannelNotificationsViewModel(roomId: viewModel.roomId))
            }
        })
        .sheet(isPresented: $showParticipantsView, content: {
            NavigationView {
                ChannelParticipantsView(
                    viewModel: viewModel,
                    showParticipantsView: $showParticipantsView
                )
            }
        })
        .sheet(isPresented: $showChannelChangeType, content: {
            NavigationView {
                SelectChannelTypeView(
                    viewModel: SelectChannelTypeViewModel(roomId: viewModel.roomId),
                    showChannelChangeType: $showChannelChangeType
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
                ChannelAddUserView(viewModel: SelectContactViewModel(mode: .add)) { selectedContacts in
                    viewModel.onInviteUsersToChannel(users: selectedContacts)
                }
            }
        })
        .sheet(isPresented: viewModel.showSelectOwner, content: {
            NavigationView {
                ChannelNewOwnerView(users: viewModel.getChannelUsers().filter({
                    viewModel.getUserRole($0.matrixId) != .owner
                })) { selectedContacts in
                    viewModel.onAssignNewOwners(users: selectedContacts) {
                        isLeaveChannel = true
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        })
        .sheet(isPresented: viewModel.showUserSettings, content: {
            UserSettingsAssembly.build(
                userId: viewModel.tappedUserId,
                showBottomSheet: viewModel.showChangeRole,
                showUserProfile: viewModel.showUserProfile,
                roomId: viewModel.roomId,
                roleCompare: viewModel.compareRoles()
            ) {
                viewModel.showUserSettings.wrappedValue = false
                viewModel.onUserRemoved()
            }
            .presentationDetents([viewModel.compareRoles() ? .height(223) : .height(109)])
        })
        .customConfirmDialog(
            isPresented: viewModel.showMakeRole,
            actionsAlignment: .center,
            actions: {
                TextActionViewModel
                    .MakeRole
                    .actions(viewModel.showMakeRole) {
                        viewModel.onMakeRoleTap()
                    }
            }, cancelActions: {
                TextActionViewModel
                    .MakeRole
                    .cancelActions(viewModel.showMakeRole)
            })
        .customConfirmDialog(
            isPresented: viewModel.showChangeRole,
            actionsAlignment: .center,
            actions: {
                TextActionViewModel
                    .SelectRole
                    .actions(viewModel.showChangeRole,
                             viewModel.getCurrentUserRole()) {
                        viewModel.onRoleSelected(role: $0)
                    }
            }, cancelActions: {
                TextActionViewModel
                    .SelectRole
                    .cancelActions(viewModel.showChangeRole)
            })
        .customConfirmDialog(
            isPresented: viewModel.showDeleteChannel,
            actionsAlignment: .center,
            actions: {
                TextActionViewModel
                    .DeleteChannel
                    .actions(viewModel.showDeleteChannel) {
                        viewModel.showLeaveChannel.wrappedValue = true
                    } onDeleteAllUsers: {
                        viewModel.onDeleteAllUsers()
                    }
                
            }, cancelActions: {
                TextActionViewModel
                    .DeleteChannel
                    .cancelActions(viewModel.showDeleteChannel)
            })
        .customConfirmDialog(
            isPresented: viewModel.showLeaveChannel,
            actionsAlignment: .center,
            actions: {
                TextActionViewModel
                    .LeaveChannel
                    .actions(viewModel.showLeaveChannel,
                             viewModel.isRoomPublicValue) {
                        viewModel.onLeaveChannel()
                        if !viewModel.compareRoles() {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
            }, cancelActions: {
                TextActionViewModel
                    .LeaveChannel
                    .cancelActions(viewModel.showLeaveChannel)
            })
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: resources.linkCopied,
                color: .green
            )
        }
        .onAppear {
            UITextView.appearance().background(.white())
        }
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
                    participantsHeader()
                        .listRowSeparator(.hidden)
                    channelParticipantsView()
                    participantsFooter()
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity)
                        .listRowInsets(.none)
                }
            }
            Section {
                copyLinkView()
                leaveChannelView()
            }
        }
    }

    private var changeView: some View {
        List {
            changeGroupInfoView
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            Section {
                changeChannelTypeView()
                if viewModel.getCurrentUserRole() == .owner {
                    deleteChannelView()
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Private Methods

    private func changeAvatarView() -> some View {
        ZStack(alignment: .center) {
            Circle()
                .foregroundColor(.cyan)
                .frame(width: 80, height: 80)
            ZStack(alignment: .center) {
                Circle()
                    .foregroundColor(.azureRadianceApprox)
                    .frame(width: 24, height: 24)
                R.image.profileDetail.camera.image
                    .resizable()
                    .frame(width: 10.5, height: 8.2)
            }
            .padding([.top, .leading], 56)
        }
    }

    private var changeGroupInfoView: some View {
        VStack(spacing: 10) {
            changeAvatarView()
            TextFieldView(
                title: "",
                text: viewModel.channelName,
                placeholder: "",
                color: Palette.white()
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
            )
            
            TextEditor(text: viewModel.channelTopic)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                .background(.white())
                .foreground(.black())
                .font(.system(size: 17))
                .frame(height: 134)
                .cornerRadius(8)
                .keyboardType(.alphabet)
        }
    }

    private func screenHeaderView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
                .frame(height: 1)
            Circle()
                .foregroundColor(.cyan)
                .frame(width: 80, height: 80)
                .padding(.bottom, 16)
            Text(viewModel.channelNameText)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .padding(.bottom, 4)
            Text("\(viewModel.getChannelUsers().count) \(resources.participant)")
                .font(.system(size: 15))
                .foregroundColor(.regentGrayApprox)
        }
    }
    
    private func channelDescriptionView() -> some View {
        Text(viewModel.channelTopicText)
            .font(.system(size: 17))
            .foregroundColor(.black)
    }
    
    private func attachmentsView() -> some View {
        ChannelSettingsView(
            title: resources.attachments,
            imageName: "folder",
            accessoryImageName: "chevron.right"
        )
        .onTapGesture {
            viewModel.nextScene(.onMedia(viewModel.roomId))
        }
    }

    private func notificationsView() -> some View {
        ChannelSettingsView(
            title: resources.notifications,
            imageName: "bell",
            accessoryImageName: "chevron.right"
        )
        .onTapGesture {
            showNotificationsView = true
        }
    }

    private func copyLinkView() -> some View {
        ChannelSettingsView(
            title: resources.copyLink,
            imageName: "doc.on.doc",
            accessoryImageName: ""
        )
        .onTapGesture {
            UIPasteboard.general.string = viewModel.roomId
            viewModel.onChannelLinkCopy()
        }
    }

    private func leaveChannelView() -> some View {
        ChannelSettingsView(
            title: resources.leaveChannel,
            titleColor: .amaranthApprox,
            imageName: "rectangle.portrait.and.arrow.right",
            imageColor: .amaranthApprox,
            accessoryImageName: ""
        )
        .onTapGesture {
            viewModel.showLeaveChannel.wrappedValue = true
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
                showChannelChangeType = true
            }
        }
    }

    private func deleteChannelView() -> some View {
        ChannelSettingsView(
            title: resources.deleteChannel,
            titleColor: .amaranthApprox,
            imageName: "trash",
            imageColor: .amaranthApprox,
            accessoryImageName: ""
        )
        .onTapGesture {
            viewModel.showDeleteChannel.wrappedValue = true
        }
    }

    private func participantsHeader() -> some View {
        HStack {
            Text(resources.participants)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            Spacer()
            Text(resources.add)
                .font(.system(size: 17))
                .foregroundColor(.azureRadianceApprox)
                .onTapGesture {
                    showAddUser = true
                }
        }
    }

    @ViewBuilder
    private func channelParticipantsView() -> some View {
        ForEach(viewModel.getChannelUsers(), id: \.self) { item in
            if viewModel.getChannelUsers().firstIndex(of: item) ?? 2 < 2 {
                ChannelParticipantView(
                    title: item.name,
                    subtitle: item.role.text
                )
                .background(.white())
                .onTapGesture {
                    viewModel.tappedUserId.wrappedValue = item.matrixId
                    viewModel.showUserSettings.wrappedValue = true
                }
            }
        }
    }

    private func participantsFooter() -> some View {
        return Text("\(resources.lookAll) ( \(viewModel.getChannelUsers().count) \(resources.participant) )")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.azureRadianceApprox)
            .onTapGesture {
                showParticipantsView = true
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
                        .font(.system(size: 17))
                        .foregroundColor(.azureRadianceApprox)
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
                    .font(.system(size: 17))
                    .foregroundColor(.azureRadianceApprox)
            })
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.shouldChange = true
                changeScreen(isEdit: false)
            }, label: {
                Text(resources.rightButton)
                    .font(.bold(17))
                    .foregroundColor(.azureRadianceApprox)
            })
        }
    }

    private func changeScreen(isEdit: Bool) {
        withAnimation(.linear(duration: 0.35)) {
            changeViewEdit = isEdit
        }
    }
}

// MARK: - TextFieldChannelView

struct TextFieldChannelView: View {

    // MARK: - Internal Properties

    @Binding var text: String
    var placeholder: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("",
                      text: $text)
                .foreground(.black())
                .background(.white())
                .cornerRadius(radius: 8, corners: .allCorners)
                .frame(height: 46)
                .font(.regular(15))
                .padding([.leading, .trailing], 16)
        }
    }
}
