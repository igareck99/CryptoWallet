import SwiftUI

// MARK: - SocialListItemView

struct SocialListItemView: View {

    // MARK: - Private Properties

    private(set) var item: SocialListItem

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            item.socialNetworkImage
                .padding(.leading, 16)
            Text(item.url)
                .font(.regular(15))
                .lineLimit(1)
            Spacer()
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
                    SocialListItemView(item: item)
                        .frame(height: 64)
                        .background(.blue(0.1))
                        .listRowSeparator(.hidden)
                        .ignoresSafeArea()
                }
                Spacer().listRowSeparator(.hidden)
                    .environment(\.editMode, self.$editMode)
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        .listStyle(.inset)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.profileNetworkDetailTitle())
                    .font(.bold(15))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Сохраняемся дева4ки")
                    presentationMode.wrappedValue.dismiss() 
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
