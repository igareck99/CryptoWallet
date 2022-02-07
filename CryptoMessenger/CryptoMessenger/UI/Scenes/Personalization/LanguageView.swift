import SwiftUI

// MARK: - LanguageCellView

struct LanguageCellView: View {

    // MARK: - Internal Properties

    var language: LanguageItem
    var user: UserPersonalizationItem

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(language.language.languageTitle)
                    .font(.semibold(15))
                Text(language.language.languageDescription)
                    .font(.regular(13))
                    .foreground(.gray())
            }
            Spacer()
            R.image.countryCode.check.image.opacity(language.language == user.language ? 1 : 0)
        }
    }

}

// MARK: - LanguageView

struct LanguageView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: PersonalizationViewModel

    // MARK: - Body

    var body: some View {
            VStack(spacing: 16) {
                Divider()
                List {
                    ForEach(viewModel.languages) { item in
                        LanguageCellView(language: item, user: viewModel.user)
                            .background(.white())
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                viewModel.updateLanguage(value: item.language)
                            }
                    }
                }
                .onAppear {
                    viewModel.send(.onAppear)
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
