import SwiftUI

// MARK: - LanguageNewCellView

struct LanguageNewCellView: View {

    // MARK: - Internal Properties

    var language: LanguageNewItem
    var user: UserPersonalizationItem

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(language.language.languageTitle)
                    .font(.bold(15))
                Text(language.language.languageDescription)
                    .font(.regular(13))
                    .foreground(.gray())
            }
            Spacer()
            R.image.countryCode.check.image.opacity(language.language == user.language ? 1 : 0)
        }
    }

}

// MARK: - LanguageNewView

struct LanguageNewView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: PersonalizationNewViewModel

    // MARK: - Body

    var body: some View {
            VStack(spacing: 16) {
                Divider()
                List {
                    ForEach(viewModel.languages) { item in
                        LanguageNewCellView(language: item, user: viewModel.user)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                viewModel.user.language = item.language
                                viewModel.userCredentials.userPersonalization = viewModel.user
                            }
                    }
                }
                .listStyle(.inset)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(R.string.localizable.personalizationTitle())
                            .font(.bold(15))
                    }
                }
            }
    }
}
