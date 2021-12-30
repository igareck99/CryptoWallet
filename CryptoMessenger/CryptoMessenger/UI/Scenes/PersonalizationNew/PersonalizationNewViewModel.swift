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

    @Injectable var userCredentialsStorageService: UserCredentialsStorageService

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
        if user.typography == self.user.typography && user.language == self.user.language &&
            user.backGround == self.user.backGround && user.theme == self.user.theme {
            user = userCredentialsStorageService.userPersonalization
        }
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}

// MARK: - LanguageItems

enum LanguageItems {

    // MARK: - Types

    case russian
    case system
    case french
    case spanish
    case arabic
    case german
    case english
    case chinese

    // MARK: - Internal Properties

    var languageTitle: String {
        switch self {
        case .russian:
            return "Русский язык"
        case .system:
            return "Как в системе"
        case .french:
            return "Французский язык"
        case .spanish:
            return "Испанский язык"
        case .arabic:
            return "Арабский язык"
        case .german:
            return "Немецкий язык"
        case .english:
            return "Английский язык"
        case .chinese:
            return "Китайский язык"
        }
    }

    var languageDescription: String {
        switch self {
        case .russian:
            return "Russian"
        case .system:
            return "Как в системе (Русский)"
        case .french:
            return "French"
        case .spanish:
            return "Spanish"
        case .arabic:
            return "Arabic"
        case .german:
            return "German"
        case .english:
            return "English"
        case .chinese:
            return "中國人"
        }
}
}

// MARK: - LanguageNewItem

struct LanguageNewItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var language: LanguageItems

}

// MARK: - UserPersonalizationItem

struct UserPersonalizationItem {

    // MARK: - Internal Properties

    var language: LanguageItems
    var theme: ThemeNewItemCase
    var backGround: Image
    var typography: TypographyItemCase
}

// MARK: - PersonalizationTitleItem

enum PersonalizationTitleCase {

    // MARK: - Types

    case lagnguage
    case theme
    case backGround
    case typography

    // MARK: - Internal Properties

    var text: String {
        switch self {
        case .lagnguage:
            return "Язык приложения"
        case .theme:
            return "Тема"
        case .backGround:
            return "Фон профиля"
        case .typography:
            return "Типографика"
        }
    }
}

struct PersonalitionTitleItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var title: PersonalizationTitleCase
}
