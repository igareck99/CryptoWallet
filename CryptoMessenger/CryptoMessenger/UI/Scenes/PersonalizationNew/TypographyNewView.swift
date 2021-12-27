import SwiftUI

// MARK: - TypographyNewView

struct TypographyNewCellView: View {

    // MARK: - Internal Properties

    var typography: TypographyNewItem
    var user: UserPersonalizationItem

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(typography.title.name)
                    .font(.bold(typography.title.bigSize))
                Text(typography.title.sizeTitle)
                    .font(.regular(typography.title.littleSize))
                    .foreground(.gray())
            }
            Spacer()
            R.image.countryCode.check.image.opacity(typography.title == user.typography ? 1 : 0)
        }
    }

}

// MARK: - TypographyNewView

struct TypographyNewView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: PersonalizationNewViewModel
    @Binding var showTypographyScreen: Bool

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.typographyTitles) { item in
                        TypographyNewCellView(typography: item,
                                              user: viewModel.user)
                            .onTapGesture {
                                viewModel.user.typography = item.title
                            }
                    }
                }
            }
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.typographyTitle())
                        .font(.bold(15))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    R.image.callList.back.image
                        .onTapGesture {
                            showTypographyScreen = false
                        }
                }
            }
        }
    }
}

//struct TypographyNewViewPreview: PreviewProvider {
//    static var previews: some View {
//        TypographyNewView(viewModel: PersonalizationNewViewModel())
//    }
//}
