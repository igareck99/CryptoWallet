import SwiftUI

// MARK: - BlockedUserView

struct BlockedUserView: View {

    // MARK: - Internal Properties

    var item: BlockedUserItem

    // MARK: - Body

    var body: some View {
        HStack {
            Image(uiImage: item.photo)
                .resizable()
                .frame(width: 40, height: 40)
                .offset(x: -4)
                .cornerRadius(20)
                .padding(.leading, 16)
                .padding(.top, 0)
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.bold(15))
                    .lineLimit(1)
                Text(item.status)
                    .font(.regular(12))
                    .foreground(.darkGray())
                    .lineLimit(1)
                Spacer()
            }
            .offset(x: 1)
            .padding(.top, 11)
        }
    }
}

// MARK: - BlockedUserContentView

struct BlockedUserContentView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel = BlockListViewModel()

    // MARK: - Private Properties

    @State private var showingAlert = false
    @State private var currentUser = -1

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.listData) { user in
                    BlockedUserView(item: user).onTapGesture {
                        showingAlert.toggle()
                        currentUser = viewModel.listData.firstIndex(
                            where: { $0.id == user.id }) ?? -1
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(
                        R.string.localizable.blockedUserAlertTitle() + viewModel.listData[currentUser].name
                    ),
                          message: nil,
                          primaryButton:
                                .default(Text(R.string.localizable.blockedUserApprove()), action: {
                        viewModel.listData.remove(at: currentUser)
                    }),
                          secondaryButton: .default(Text(R.string.localizable.blockedUserCancel())))
                }
            }
            .navigationBarTitle(R.string.localizable.blackListTitle(), displayMode: .inline)
            .listSeparatorStyle(style: .none)
            .listStyle(.inset)
            .padding([.leading, .trailing], -20)
        }
    }
}
