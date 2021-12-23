import SwiftUI

// MARK: - SocialListItemView

struct SocialListItemView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel = SocialListViewModel()

    // MARK: - Private Properties

    @State private var editMode = ButtonAddingState.adding
    private(set) var item: SocialListItem

    // MARK: - Body

    var body: some View {
        HStack {
            Text(item.url)
                    .font(.regular(15))
                    .lineLimit(1)
                Spacer()
            }.background(.lightBlue())
    }
}

// MARK: - AddSocialCellView

struct AddSocialCellView: View {

    // MARK: - Body

    var body: some View {
        HStack(spacing: 20) {
            R.image.profileNetworkDetail.approveSmall.image
                    .resizable()
                    .frame(width: 22, height: 22)
                    .padding(.leading, 2)
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
    @State var sectionSwitch = false
    @State var headerMode: EditMode = .inactive

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
                        Section {
                            ForEach(viewModel.listData) { item in
                            switch item.type {
                            case .show:
                                SocialListItemView(item: item)
                                    .listRowSeparator(.hidden)
                            case .notShow:
                                EmptyView()
                            }
                            }
                            .onDelete(perform: onDelete)
                            .onMove(perform: onMove)
                        }
                        Section(header: SocialListHeaderView()) {
                            ForEach(viewModel.listData) { item in
                            switch item.type {
                            case .show:
                                EmptyView()
                            case .notShow:
                                SocialListItemView(item: item)
                                    .listRowSeparator(.hidden)
                            }
                            }
                            .onMove(perform: onMove)
                            .onDelete(perform: onDelete)
                                .listRowSeparator(.hidden)
                        }
                    AddSocialCellView().onTapGesture {
                    }.listRowSeparator(.hidden)
                Spacer().listRowSeparator(.hidden)
                }
                .environment(\.editMode, self.$editMode)
                    .listStyle(.inset)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(R.string.localizable.profileNetworkDetailTitle())
                            .font(.bold(15))
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        R.image.callList.back.image
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                    }, label: {
                        Text(R.string.localizable.profileDetailRightButton())
                            .font(.bold(15))
                            .foreground(.blue())
                    })
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

struct SocialListHeaderView: View {

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

    // MARK: - Types

    case show
    case adding
}

// MARK: - SocialListPreviews

struct SocialListPreviews: PreviewProvider {
    static var previews: some View {
        SocialListView()
    }
}
