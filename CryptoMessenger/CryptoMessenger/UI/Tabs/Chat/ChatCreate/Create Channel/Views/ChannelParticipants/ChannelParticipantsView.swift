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
                        .font(.system(size: 17, weight: .regular))
                        .padding(.leading, 16)
                    Divider()
                        .padding(.top, 11)
                    cellStatus
                }
            }
            .navigationBarHidden(false)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                createToolBar()
            }
            .customConfirmDialog(
                isPresented: viewModel.showMakeNewRole,
                actionsAlignment: .center,
                actions: {
                    TextActionViewModel
                        .MakeNewRole
                        .actions(viewModel.showMakeNewRole) {
                            if showParticipantsView {
                                viewModel.onMakeCurrentUserRoleTap()
                            }
                        }
                }, cancelActions: {
                    TextActionViewModel
                        .MakeNewRole
                        .cancelActions(viewModel.showMakeNewRole)
                })
            .sheet(isPresented: viewModel.showSelectCurrentUserRole, content: {
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
            .customConfirmDialog(
                isPresented: viewModel.showChangeRole,
                actionsAlignment: .center,
                actions: {
                    TextActionViewModel
                        .SelectRole
                        .actions(viewModel.showChangeRole,
                                 viewModel.getCurrentUserRole()) {
                            selectedRole = $0
                            viewModel.onRoleSelected(role: $0, ownerCheck: true)
                        }
                }, cancelActions: {
                    TextActionViewModel
                        .SelectRole
                        .cancelActions(viewModel.showChangeRole)
                })
            .sheet(isPresented: viewModel.showUserSettings, content: {
                UserSettingsAssembly.build(userId: viewModel.tappedUserId,
                                           showBottomSheet: viewModel.showChangeRole,
                                           showUserProfile: viewModel.showUserProfile,
                                           roomId: viewModel.roomId,
                                           roleCompare: viewModel.compareRoles()) {
                    viewModel.showUserSettings.wrappedValue = false
                    viewModel.onUserRemoved()
                } onUserProfile: {
                    showParticipantsView = false
                    presentationMode.wrappedValue.dismiss()
                    viewModel.showUserSettings.wrappedValue = false
                }
                .presentationDetents([.height(computeSizeOfUserMenu(viewModel.compareRoles()))])
            })
        }
    }

    // MARK: - Private Properties

    private var cellStatus: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.getChannelUsers(), id: \.self) { item in
                VStack {
                    HStack {
                        ChannelParticipantView(
                            title: item.name,
                            subtitle: item.role.text
                        )
                        .onTapGesture {
                            viewModel.tappedUserId.wrappedValue = item.matrixId
                            viewModel.showUserSettings.wrappedValue = true
                        }
                        Spacer()
                    }
                    Divider()
                        .padding(.leading, 64)
                }
                .background(.white)
                .frame(height: 64)
                .padding(.horizontal, 16)
            }
        }
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
                .font(.system(size: 17, weight: .bold))
                .lineLimit(1)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                showParticipantsView = false
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.system(size: 15,weight: .bold))
                    .foregroundColor(.dodgerBlue)
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
}
