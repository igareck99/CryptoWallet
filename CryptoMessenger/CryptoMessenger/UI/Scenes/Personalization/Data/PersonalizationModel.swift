import SwiftUI
import Combine

// MARK: - PersonalizationViewModel

final class PersonalizationViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: PersonalizationSceneDelegate?
    @Published var languages = [LanguageItem(language: .russian),
                                LanguageItem(language: .system),
                                LanguageItem(language: .french),
                                LanguageItem(language: .spanish),
                                LanguageItem(language: .arabic),
                                LanguageItem(language: .german),
                                LanguageItem(language: .english),
                                LanguageItem(language: .chinese)]
    @Published var personalizationTitles = [PersonalitionTitleItem(title: .lagnguage),
                                            PersonalitionTitleItem(title: .theme),
                                            PersonalitionTitleItem(title: .backGround),
                                            PersonalitionTitleItem(title: .typography)]
    @Published var typographyTitles = [
        TypographyItem(title: .little),
        TypographyItem(title: .middle),
        TypographyItem(title: .big)
    ]
    @Published var themes = [
        ThemeItem(title: .system),
        ThemeItem(title: .light),
        ThemeItem(title: .dark)
    ]
    @Published var user = UserPersonalizationItem(language: .chinese,
                                                  theme: .system,
                                                  backGround: Image(uiImage: UIImage()),
                                                  typography: .standart)
    @Published var backgroundPhotos = [
        R.image.profileBackground.image1.image,
        R.image.profileBackground.image2.image,
        R.image.profileBackground.image3.image,
        R.image.profileBackground.image4.image,
        R.image.profileBackground.image5.image,
        R.image.profileBackground.image6.image,
        R.image.profileBackground.image7.image
    ]
    @Published var selectedImage: UIImage?
    @Published var typography = ""
    @Published var language = ""
    @Published var theme = ""
    @Published var dataImage: Int?
    @Published private(set) var state: PersonalizationNewFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<PersonalizationNewFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<PersonalizationNewFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let userCredentials: UserCredentialsStorage

    // MARK: - Lifecycle

    init(
		userCredentials: UserCredentialsStorage
	) {
		self.userCredentials = userCredentials
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func addPhoto(image: UIImage) {
        backgroundPhotos.append(Image(uiImage: image))
    }

    func send(_ event: PersonalizationNewFlow.Event) {
        eventSubject.send(event)
    }

    func updateLanguage(value: LanguageItems) {
        user.language = value
        userCredentials.language = value.languageDescription
    }

    func updateTypography(value: TypographyItemCase) {
        user.typography = value
        userCredentials.typography = value.name
    }

    func updateTheme(value: ThemeItemCase) {
        user.theme = value
        userCredentials.theme = value.name
    }

    func updateImage(index: Int) {
        dataImage = index
        userCredentials.profileBackgroundImage = index
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject.sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onProfile:
                    self?.delegate?.handleNextScene(.profile)
                case .onLanguage:
                    self?.delegate?.handleNextScene(.language)
                case .onTypography:
                    self?.delegate?.handleNextScene(.typography)
                case .onSelectBackground:
                    self?.delegate?.handleNextScene(.selectBackground)
                case .backgroundPreview:
                    self?.updateData()
                    self?.delegate?.handleNextScene(.profilePreview)
                }
        }.store(in: &subscriptions)

        $selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.addPhoto(image: image)
            }
            .store(in: &subscriptions)
    }

    private func updateData() {
		typography = userCredentials.typography ?? ""
        language = userCredentials.language ?? ""
        theme = userCredentials.theme ?? ""
        var userImage = Image(uiImage: UIImage())
        if userCredentials.profileBackgroundImage == -1 {
            userImage = Image(uiImage: UIImage())
            dataImage = -1
        } else if userCredentials.profileBackgroundImage > backgroundPhotos.count {
            userImage = backgroundPhotos[backgroundPhotos.count - 1]
            dataImage = backgroundPhotos.count - 1
        } else {
            userImage = backgroundPhotos[userCredentials.profileBackgroundImage]
            dataImage = userCredentials.profileBackgroundImage
        }
        debugPrint(userCredentials.profileBackgroundImage)
        user = UserPersonalizationItem(language: LanguageItems.save(item: language),
                                       theme: ThemeItemCase.save(item: theme),
                                       backGround: userImage,
                                       typography: TypographyItemCase.save(item: typography))
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
