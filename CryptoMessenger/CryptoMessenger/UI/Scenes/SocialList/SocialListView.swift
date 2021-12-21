import SwiftUI

// MARK: - SocialListItemView

struct SocialListItemView: View {

    // MARK: - Internal Properties

    var item: SocialListItem
    @State private var editMode = ButtonAddingState.adding
    @ObservedObject var viewModel = SocialListViewModel()

    // MARK: - Body

    var body: some View {
        switch viewModel.listData.firstIndex(of: item) == viewModel.getLastShow() - 1 {
        case true:
            VStack(alignment: .leading) {
                ListHeaderView()
            HStack {
                Image(uiImage: R.image.profileNetworkDetail.cancelSmall() ?? UIImage())
                    .frame(width: 16, height: 16)
                    .offset(x: -4)
                Text(item.url)
                        .font(.regular(15))
                        .lineLimit(1)
                    Spacer()
                Image(uiImage: R.image.profileNetworkDetail.dragDrop() ?? UIImage())
            }
        }.background(.lightBlue())
        case false:
            HStack {
                Image(uiImage: R.image.profileNetworkDetail.cancelSmall() ?? UIImage())
                    .frame(width: 16, height: 16)
                    .offset(x: -4)
                Text(item.url)
                        .font(.regular(15))
                        .lineLimit(1)
                    Spacer()
                Image(uiImage: R.image.profileNetworkDetail.dragDrop() ?? UIImage())
            }.background(.lightBlue())
        }
    }
}

// MARK: - AddSocialCellView

struct AddSocialCellView: View {

    // MARK: - Internal Properties

    // MARK: - Body

    var body: some View {
            HStack {
                Image(uiImage: R.image.profileNetworkDetail.approveSmall() ?? UIImage())
                    .frame(width: 16, height: 16)
                    .offset(x: -4)
                Text(R.string.localizable.profileNetworkDetailNotShowLink())
                        .font(.regular(15))
                        .lineLimit(1)
            }.background(.lightBlue())
    }
}

// MARK: - SocialListView

struct SocialListView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel = SocialListViewModel()
    @State var editMode: EditMode = .active

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                Text(R.string.localizable.profileNetworkDetailMain())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.top, 24)
                    .padding(.leading)
                Text(R.string.localizable.profileNetworkDetailMessage())
                    .font(.regular(12))
                    .foreground(.darkGray())
                    .padding(.leading)
                List {
                    ForEach(viewModel.listData) { item in
                        SocialListItemView(item: item)
                            .listRowSeparator(.hidden)
                    }.onMove { indexSet, index in
                        if index > self.viewModel.getLastShow() {
                            self.viewModel.listData[index].type = .notShow
                        } else {
                            self.viewModel.listData[index].type = .show
                        }
                        self.viewModel.listData.move(fromOffsets: indexSet, toOffset: index)
                        print(self.viewModel.listData)
                    }
                    .onDelete(perform: onDelete)
                        .listRowSeparator(.hidden)
                    AddSocialCellView().onTapGesture {
                    }.listRowSeparator(.hidden)
                Spacer().listRowSeparator(.hidden)
                }
                    .listStyle(.inset)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(R.string.localizable.profileNetworkDetailTitle())
                            .font(.bold(15))
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(uiImage: R.image.callList.back() ?? UIImage())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .font(.bold(15))
                        .foreground(.blue())
            }
                }
        }
    }
}

    // MARK: - Private Methods

    func onMove(fromOffsets source: IndexSet, toOffset destination: Int) {
        viewModel.listData.move(fromOffsets: source, toOffset: destination)
    }

    private func onDelete(offsets: IndexSet) {
        viewModel.listData.remove(atOffsets: offsets)
    }
}

// MARK: - ListHeaderView

struct ListHeaderView: View {

    // MARK: - Body

    var body: some View {
        HStack(alignment: .bottom) {
            Text(R.string.localizable.profileNetworkDetailNotShowMessage())
                .font(.bold(12))
                .foreground(.darkGray())
        }
    }
}

// MARK: - ButtonAddingState

enum ButtonAddingState {
    case show
    case adding
}

// MARK: - SocialListPreviews

struct SocialListPreviews: PreviewProvider {
    static var previews: some View {
        SocialListView()
    }
}
