import SwiftUI

// MARK: - ChannelNotificaionsView

struct ChannelParticipantsView<ViewModel: ChannelInfoViewModelProtocol>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @Binding var showParticipantsView: Bool
    @State private var showMenuView = false
    @State var selectedUser: ChannelParticipantsData?
    @State private var showUserSettings = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Добавить пользователя")
                    .foreground(.darkGray())
                    .font(.regular(17))
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
            .presentationDetents([viewModel.compareRoles() ? .height(223) : .height(109)])
        })
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
            Text("Все участники")
                .font(.bold(17))
                .lineLimit(1)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                showParticipantsView = false
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.bold(15))
                    .foregroundColor(.blue)
            })
        }
    }
}
