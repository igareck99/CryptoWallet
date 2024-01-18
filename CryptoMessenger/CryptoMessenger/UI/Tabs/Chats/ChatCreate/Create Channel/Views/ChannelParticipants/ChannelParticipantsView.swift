import SwiftUI

// MARK: - ChannelParticipantsView

struct ChannelParticipantsView<ViewModel: ChannelInfoViewModelProtocol>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel
    @StateObject var participantsViewModel: ChannelParticipantsViewModel

    // MARK: - Private Properties

    @Binding var showParticipantsView: Bool
    @State private var showMenuView = false
    @State var selectedUser: ChannelParticipantsData?
    @State var chatData = ChatData.emptyObject()
    @State private var showUserSettings = false
    @State private var selectedRole: ChannelRole?
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                Divider()
                    .foreground(.brightGray)
                    .frame(height: 0.5)
                cellStatus
                    .searchable(text: $viewModel.searchText)
            }
            .listStyle(.inset)
            .onDisappear {
                viewModel.searchText = ""
            }
            .navigationBarHidden(false)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                createToolBar()
            }
            .customConfirmDialog(
                isPresented: $viewModel.showMakeNewRole,
                actionsAlignment: .center,
                actions: {
                    TextActionViewModel
                        .MakeNewRole
                        .actions($viewModel.showMakeNewRole) {
                            if showParticipantsView {
                                viewModel.onMakeCurrentUserRoleTap()
                            }
                        }
                }, cancelActions: {
                    TextActionViewModel
                        .MakeNewRole
                        .cancelActions($viewModel.showMakeNewRole)
                })
            .sheet(isPresented: $viewModel.showSelectCurrentUserRole, content: {
                NavigationView {
                    ChannelNewOwnerView(
                        // TODO: Вынести в метод ViewModel
                        users: viewModel.getChannelUsers().filter({
                        viewModel.getUserRole(userId: $0.matrixId) != .owner
                    })) { selectedContacts in
                        viewModel.onAssignAnotherOwners(
                            users: selectedContacts,
                            newRole: selectedRole
                        ) {
                            // ???
                        }
                    }
                }
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
            .sheet(isPresented: $viewModel.showUserSettings, content: {
                // TODO: Переделать через роутер
                UserSettingsAssembly.build(
                    userId: $viewModel.tappedUserId,
                    showBottomSheet: $viewModel.showChangeRole,
                    showUserProfile: $viewModel.showUserProfile,
                    roomId: viewModel.room.roomId,
                    roleCompare: viewModel.compareRoles()
                ) {
                    viewModel.showUserSettings = false
                    viewModel.onUserRemoved()
                } onUserProfile: {
                    viewModel.showUserSettings = false
                    viewModel.dismissSheet()
                    participantsViewModel.coordinator?.onUserProfile(viewModel.tappedUserId, viewModel.room.roomId)
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(computeSizeOfUserMenu(viewModel.compareRoles()))])
            })
        }
    }

    // MARK: - Private Properties

    private var cellStatus: some View {
        List {
            ForEach(viewModel.getChannelUsersFiltered(), id: \.self) { item in
                VStack(spacing: .zero) {
                    HStack {
                        ChannelParticipantView(
                            avatar: item.avatar, 
                            title: item.name,
                            subtitle: item.role.text
                        )
                        .listItemTint(.brightGray)
                        .onTapGesture {
                            viewModel.tappedUserId = item.matrixId
                            viewModel.showUserSettings = true
                        }
                        Spacer()
                    }
                    .background(.white)
                    .frame(height: 43)
                }
            }
        }
        .listStyle(.plain)
    }

    // MARK: - Private methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                showParticipantsView = false
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .principal) {
            Text(R.string.localizable.createChannelAllUsers())
                .font(.bodySemibold17)
                .lineLimit(1)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                // TODO: Убрать вызов во viewModel, и сделать через роутер
                if let coordinator = participantsViewModel.coordinator {
                    coordinator.showSelectContact(mode: .channelParticipantsAdd,
                                                   chatData: $chatData, contactsLimit: nil,
                                                   channelCoordinator: coordinator,
                                                   onUsersSelected: { contacts in
                        viewModel.onInviteUsersToChannel(users: contacts)
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
            }, label: {
                R.image.channelSettings.addParticipantsPlus.image
                    .resizable()
                    .frame(width: 28, height: 28)
            })
        }
    }

    private func computeSizeOfUserMenu(_ value: ChannelUserActions) -> CGFloat {
        if value.delete && value.changeRole {
            return CGFloat(189)
        } else if value.delete || value.changeRole {
            return CGFloat(149)
        } else {
            return CGFloat(75)
        }
    }
}
