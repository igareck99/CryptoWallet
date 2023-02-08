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
        .sheet(isPresented: viewModel.showUserSettings, content: {
            UserSettingsAssembly.build(
                userId: viewModel.tappedUserId,
                showBottomSheet: viewModel.showChangeRole,
                showUserProfile: viewModel.showUserProfile,
                roomId: viewModel.roomId
            ) {
                viewModel.showUserSettings.wrappedValue = false
                showParticipantsView = false
                viewModel.onUserRemoved()
            }
            .presentationDetents([.height(223)])
        })
        .popup(isPresented: $showMenuView,
               type: .toast,
               position: .bottom,
               closeOnTap: false,
               closeOnTapOutside: true,
               backgroundColor: Color(.black(0.3))) {
            ChannelParticipantsMenuView(showMenuView: $showMenuView, data: selectedUser, onAction: { _ in
            })
                .frame(width: UIScreen.main.bounds.width,
                       height: 223,
                       alignment: .center)
                .background(.white())
                .cornerRadius(16)
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
                .onTapGesture {
                    showMenuView = true
                }
            }
        }
    }

    // MARK: - Private methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                showParticipantsView = false
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
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.bold(15))
                    .foregroundColor(.blue)
            })
        }
    }
}
