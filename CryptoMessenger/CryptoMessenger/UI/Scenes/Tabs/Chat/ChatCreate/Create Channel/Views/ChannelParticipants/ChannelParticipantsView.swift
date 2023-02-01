import SwiftUI

// MARK: - ChannelNotificaionsView

struct ChannelParticipantsView<ViewModel: ChannelInfoViewModelProtocol>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var showMenuView = false
    @State var selectedUser: ChannelParticipantsData?

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
                        Spacer()
                    }
                    Divider()
                        .padding(.leading, 64)
                }
                .background(.white)
                .frame(height: 64)
                .padding(.horizontal, 16)
                .onTapGesture {
                    selectedUser = item
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
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.bold(15))
                    .foregroundColor(.blue)
            })
        }
    }
}
