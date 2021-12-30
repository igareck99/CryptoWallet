import SwiftUI

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
