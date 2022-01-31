import SwiftUI

// MARK: - TypographyCellView

struct TypographyCellView: View {

    // MARK: - Internal Properties

    var typography: TypographyItem
    var user: UserPersonalizationItem

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(typography.title.name)
                    .font(.bold(user.typography.bigSize))
                Text(typography.title.sizeTitle)
                    .font(.regular(user.typography.littleSize))
                    .foreground(.gray())
            }
            Spacer()
            R.image.countryCode.check.image.opacity(typography.title == user.typography ? 1 : 0)
        }
    }

}

// MARK: - TypographyView

struct TypographyView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: PersonalizationViewModel

    // MARK: - Body

    var body: some View {
            VStack {
                List {
                    ForEach(viewModel.typographyTitles) { item in
                        TypographyCellView(typography: item,
                                           user: viewModel.user)
                            .onTapGesture {
                                viewModel.updateTypography(value: item.title)
                            }
                    }
                }
            }.padding(.top, 16)
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.typographyTitle())
                        .font(.bold(viewModel.user.typography.bigSize))
                }
            }
    }
}
