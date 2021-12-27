import SwiftUI

// MARK: - PersonalizationNewViewModel

final class PersonalizationNewViewModel: ObservableObject {

    // MARK: - Internal Properties

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
    @Published var user = UserPersonalizationItem(language: .chinese,
                                                  theme: "По умолчанию",
                                                  backGround: "По умолчанию",
                                                  typography: .standart)

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
    var theme: String
    var backGround: String
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
