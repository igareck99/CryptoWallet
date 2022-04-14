import SwiftUI
import UniformTypeIdentifiers

// MARK: - SocialListItemView

struct SocialListItemView: View {

    // MARK: - Private Properties

    @State var item: SocialListItem
    @StateObject var viewModel: SocialListViewModel

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            item.socialNetworkImage
                .resizable()
                .frame(width: 24,
                       height: 24)
                .padding(.leading, 16)
            TextField("", text: self.$item.url)
                .frame(height: 30)
                .onSubmit {
                    let socialItem = SocialListItem(url: self.item.url,
                                                    sortOrder: item.sortOrder,
                                                    socialType: item.socialType)
                    viewModel.updateListData(item: socialItem)
                }
            R.image.profileNetworkDetail.dragDrop.image
                .padding(.trailing, 16)
        }
    }
}

// MARK: - SocialListView

struct SocialListView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel = SocialListViewModel()
    @State var editMode: EditMode = .active
    @State var sectionSwitch = false
    @Environment(\.presentationMode) private var presentationMode
    @State private var dragging: SocialListItem?

    // MARK: - Body

    var body: some View {
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
                    SocialListItemView(item: item,
                                       viewModel: viewModel)
                        .ignoresSafeArea()
                        .listRowSeparator(.visible)
                        .onDrag {
                            self.dragging = item
                            return NSItemProvider(object: NSString())
                        }
                }
                .onMove(perform: {_, _  in })
                .listRowBackground(Color(.blue(0.1)))
                Spacer().listRowSeparator(.hidden)
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.profileNetworkDetailTitle())
                    .font(.bold(15))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    viewModel.addSocial(data: viewModel.listData)
                }, label: {
                    Text(R.string.localizable.profileDetailRightButton())
                        .font(.bold(15))
                        .foreground(.blue())
                })
            }
        }
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
