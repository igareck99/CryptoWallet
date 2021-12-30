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
    @State var showTypographyScreen = false
    @State var showThemeScreen = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            Divider().padding(.top, 16)
            List {
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[0],
                                           user: String(viewModel.user.language.languageTitle.split(separator: " ")[0]))
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        viewModel.send(.onLanguage)
                    }
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[1],
                                           user: viewModel.user.theme.name)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        showThemeScreen = true
                    }
                PersonalizationNewCellView(item: viewModel.personalizationTitles[2],
                                           user: viewModel.user.backGround == Image(uiImage: UIImage()) ?
                                           R.string.localizable.pesonalizationByDefault() : "Выбрано")
                    .onTapGesture {
                        viewModel.send(.onSelectBackground)
                    }
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[3],
                                           user: viewModel.user.typography.name)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        viewModel.send(.onTypography)
                    }
            }
        }
            .actionSheet(isPresented: $showThemeScreen) {
                ActionSheet(
                    title: Text(""),
                    buttons: [
                        .default(Text(R.string.localizable.personalizationSystem())) {
                            viewModel.user.theme = .system
                        },
                            .default(Text(R.string.localizable.personalizationLight())) {
                                viewModel.user.theme = .light
                            },
                            .default(Text(R.string.localizable.personalizationDark())) {
                                viewModel.user.theme = .dark
                            },
                        .destructive(Text(R.string.localizable.personalizationCancel()))
                    ]
                )
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.send(.onProfile)
                    }, label: {
                        Text(R.string.localizable.profileDetailRightButton())
                            .font(.bold(15))
                            .foreground(.blue())
                    })
                }
            }
    }
}

// MARK: - PersonalizationNewViewPreview

struct PersonalizationNewViewPreview: PreviewProvider {
    static var previews: some View {
        PersonalizationNewView(viewModel: PersonalizationNewViewModel())
    }
}
