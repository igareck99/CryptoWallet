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
    @Binding var showLanguageScreen: Bool

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.languages) { item in
                    LanguageNewCellView(language: item, user: viewModel.user)
                        .onTapGesture {
                            viewModel.user.language = item.language
                        }
                }
            }
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.personalizationTitle())
                        .font(.bold(15))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    R.image.callList.back.image
                        .onTapGesture {
                            showLanguageScreen = false
                        }
                }
            }
        }
    }
}


//struct LanguageNewViewPreview: PreviewProvider {
//    static var previews: some View {
//        LanguageNewView(showLanguageScreen: false)
//    }
//}
