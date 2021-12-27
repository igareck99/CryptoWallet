import SwiftUI

// MARK: - PersonalizationNewCellView

struct PersonalizationNewCellView: View {

    // MARK: - Internal Properties

    var item: PersonalitionTitleItem
    var user: String

    // MARK: - Body

    var body: some View {
        HStack {
            Text(item.title.text)
                .font(.regular(15))
            Spacer()
            HStack(spacing: 17) {
                Text(user)
                    .font(.regular(15))
                    .foreground(.darkGray())
                R.image.registration.arrow.image
            }
        }
    }
}

// MARK: - PersonalizationNewView

struct PersonalizationNewView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel = PersonalizationNewViewModel()
    @State var showLanguageScreen = false
    @State var showTypographyScreen = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[0],
                                           user: viewModel.user.language.languageTitle)
                    .onTapGesture {
                        showLanguageScreen = true
                    }
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[1],
                                           user: viewModel.user.theme)
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[2],
                                           user: viewModel.user.backGround)
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[3],
                                           user: viewModel.user.typography.name)
                    .onTapGesture {
                        showTypographyScreen = true
                    }
            }
            .fullScreenCover(isPresented: $showLanguageScreen, content: {
                LanguageNewView(viewModel: viewModel,
                                showLanguageScreen: $showLanguageScreen)
        })
            .fullScreenCover(isPresented: $showTypographyScreen, content: {
                TypographyNewView(viewModel: viewModel,
                                  showTypographyScreen: $showTypographyScreen)
        })
            .listRowSeparator(.hidden)
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.personalizationTitle())
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

// MARK: - PersonalizationNewViewPreview

struct PersonalizationNewViewPreview: PreviewProvider {
    static var previews: some View {
        //BlockedUserContentView()
        PersonalizationNewView(viewModel: PersonalizationNewViewModel())
    }
}
