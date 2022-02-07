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
                    .font(.semibold(user.typography.bigSize))
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
        Divider().padding(.top, 16)
            VStack {
                List {
                    ForEach(viewModel.typographyTitles) { item in
                        TypographyCellView(typography: item,
                                           user: viewModel.user)
                            .background(.white())
                            .listRowSeparator(.visible, edges: .bottom)
                            .listRowSeparator(item.title == .little ? .hidden : .visible)
                            .onTapGesture {
                                viewModel.updateTypography(value: item.title)
                            }
                    }
                }
            }
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.typographyTitle())
                        .frame(maxWidth: .infinity)
                        .font(.bold(viewModel.user.typography.bigSize))
                }
            }
    }
}
