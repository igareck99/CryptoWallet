import SwiftUI

// MARK: - ChannelParticipantsView

struct ChannelParticipantsView<ViewModel: ChannelInfoViewModelProtocol>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @Binding var showParticipantsView: Bool
    @State private var showMenuView = false
    @State var selectedUser: ChannelParticipantsData?
    @State private var showUserSettings = false
    @State private var selectedRole: ChannelRole?
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(R.string.localizable.createChannelAdding())
                        .foregroundColor(.romanSilver)
                        .font(.bodyRegular17)
                        .padding(.leading, 16)
                    Divider()
                        .padding(.top, 11)
                    cellStatus
                }
                Divider()
                cellStatus
                    .searchable(text: $viewModel.searchText)
            }
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
                UserSettingsAssembly.build(userId: $viewModel.tappedUserId,
                                           showBottomSheet: $viewModel.showChangeRole,
                                           showUserProfile: $viewModel.showUserProfile,
                                           roomId: viewModel.room.roomId,
                                           roleCompare: viewModel.compareRoles()) {
                    viewModel.showUserSettings = false
                    viewModel.onUserRemoved()
                } onUserProfile: {
                    showParticipantsView = false
                    presentationMode.wrappedValue.dismiss()
                    viewModel.showUserSettings = false
                }
                .presentationDetents([.height(computeSizeOfUserMenu(viewModel.compareRoles()))])
            })
        }
    }

    // MARK: - Private Properties

    private var cellStatus: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.getChannelUsersFiltered(), id: \.self) { item in
                VStack {
                    HStack {
                        ChannelParticipantView(
                            title: item.name,
                            subtitle: item.role.text
                        )
                        .onTapGesture {
                            viewModel.tappedUserId = item.matrixId
                            viewModel.showUserSettings = true
                        }
                        Spacer()
                    }
                    Divider()
                        .padding(.leading, 56)
                        .ignoresSafeArea(.all)
                }
                .background(.white)
                .frame(height: 64)
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea(.all)
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
}
