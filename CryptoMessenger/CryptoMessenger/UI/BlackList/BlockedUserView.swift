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
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.system(size: 15, weight: .bold))
                    .lineLimit(1)
                Text(item.status)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.romanSilver)
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

    @ObservedObject var viewModel: BlockListViewModel

    // MARK: - Private Properties

    @State private var showingAlert = false
    @State private var currentUser = -1

    // MARK: - Body

    var body: some View {
            List {
                ForEach(viewModel.listData) { user in
                    BlockedUserView(item: user)
                        .background(viewModel.resources.background)
                        .onTapGesture {
                        showingAlert.toggle()
                        currentUser = viewModel.listData.firstIndex(
                            where: { $0.id == user.id }) ?? -1
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(
                        viewModel.resources.blockedUserAlertTitle + viewModel.listData[currentUser].name
                    ),
                          message: nil,
                          primaryButton:
                            .default(Text(viewModel.resources.blockedUserApprove), action: {
                        viewModel.listData.remove(at: currentUser)
                    }),
                          secondaryButton: .default(Text(viewModel.resources.blockedUserCancel)))
                }
        }
        .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.resources.blackListTitle)
                        .font(.system(size: 15, weight: .bold))
                }
            }
        .listStyle(.inset)
    }
}
