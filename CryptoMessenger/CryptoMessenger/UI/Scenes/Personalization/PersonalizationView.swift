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

// MARK: - PersonalizationView

struct PersonalizationView: View {

    // MARK: - Internal Properties

	@ObservedObject var viewModel = PersonalizationViewModel(userCredentials: UserDefaultsService.shared)

    // MARK: - Private Properties

    @State private var showTypographyScreen = false
    @State private var showThemeScreen = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            Divider().padding(.top, 16)
            List {
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[0],
                                           user: viewModel.user.language.languageDescription)
                    .listRowSeparator(.hidden)
                    .background(.white())
                    .onTapGesture {
                        viewModel.send(.onLanguage)
                    }
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[1],
                                           user: viewModel.user.theme.name)
                    .listRowSeparator(.hidden)
                    .background(.white())
                    .onTapGesture {
                        showThemeScreen = true
                    }
                PersonalizationNewCellView(item: viewModel.personalizationTitles[2],
                                           user: viewModel.user.backGround == Image(uiImage: UIImage()) ?
                                           R.string.localizable.pesonalizationByDefault() : "Выбрано")
                    .background(.white())
                    .onTapGesture {
                        viewModel.send(.onSelectBackground)
                    }
                PersonalizationNewCellView(item:
                                            viewModel.personalizationTitles[3],
                                           user: viewModel.user.typography.name)
                    .listRowSeparator(.hidden)
                    .background(.white())
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
                            viewModel.updateTheme(value: .system)
                        },
                            .default(Text(R.string.localizable.personalizationLight())) {
                                viewModel.updateTheme(value: .light)
                            },
                            .default(Text(R.string.localizable.personalizationDark())) {
                                viewModel.updateTheme(value: .dark)
                            },
                        .destructive(Text(R.string.localizable.personalizationCancel()))
                    ]
                )
            }
            .onAppear {
                viewModel.send(.onAppear)
            }
            .onDisappear {
                showTabBar()
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
