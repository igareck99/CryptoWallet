import SwiftUI
import Combine

// MARK: - PersonalizationNewViewModel

final class PersonalizationNewViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: PersonalizationNewSceneDelegate?
    @Published var languages = [LanguageNewItem(language: .russian),
                                LanguageNewItem(language: .system),
                                LanguageNewItem(language: .french),
                                LanguageNewItem(language: .spanish),
                                LanguageNewItem(language: .arabic),
                                LanguageNewItem(language: .german),
                                LanguageNewItem(language: .english),
                                LanguageNewItem(language: .chinese)]
    @Published var personalizationTitles = [PersonalitionTitleItem(title: .lagnguage),
                                            PersonalitionTitleItem(title: .theme),
                                            PersonalitionTitleItem(title: .backGround),
                                            PersonalitionTitleItem(title: .typography)]
    @Published var typographyTitles = [
        TypographyNewItem(title: .little),
        TypographyNewItem(title: .middle),
        TypographyNewItem(title: .big)
    ]
    @Published var themes = [
        ThemeNewItem(title: .system),
        ThemeNewItem(title: .light),
        ThemeNewItem(title: .dark)
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

    // MARK: - Private Properties

    @Published private(set) var state: PersonalizationNewFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<PersonalizationNewFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<PersonalizationNewFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable var userCredentials: UserCredentialsStorageService

    // MARK: - Lifecycle

    init() {
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

    func upadateLanguage(value: LanguageItems) {
        print(user)
        user.language = value
        print(user)
        self.userCredentials.userPersonalization = user
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
                    self?.delegate?.handleNextScene(.profilePreview)
                }
        }.store(in: &subscriptions)
    }

    private func updateData() {
        user = userCredentials.userPersonalization
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}
