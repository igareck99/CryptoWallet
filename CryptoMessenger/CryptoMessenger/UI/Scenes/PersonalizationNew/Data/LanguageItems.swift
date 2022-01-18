import SwiftUI

// MARK: - LanguageItems

enum LanguageItems: Codable {

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
            return R.string.localizable.appLanguageLanguageTitleRussian()
        case .system:
            return R.string.localizable.appLanguageLanguageTitleSystem()
        case .french:
            return R.string.localizable.appLanguageLanguageTitleFrench()
        case .spanish:
            return R.string.localizable.appLanguageLanguageTitleSpanish()
        case .arabic:
            return R.string.localizable.appLanguageLanguageTitleArabic()
        case .german:
            return R.string.localizable.appLanguageLanguageTitleGerman()
        case .english:
            return R.string.localizable.appLanguageLanguageTitleEnglish()
        case .chinese:
            return R.string.localizable.appLanguageLanguageTitleChiniese()
        }
    }

    var languageDescription: String {
        switch self {
        case .russian:
            return R.string.localizable.appLanguageLanguageDescriptionRussian()
        case .system:
            return R.string.localizable.appLanguageLanguageDescriptionSystem()
        case .french:
            return R.string.localizable.appLanguageLanguageDescriptionFrench()
        case .spanish:
            return R.string.localizable.appLanguageLanguageDescriptionSpanish()
        case .arabic:
            return R.string.localizable.appLanguageLanguageDescriptionArabic()
        case .german:
            return R.string.localizable.appLanguageLanguageDescriptionGerman()
        case .english:
            return R.string.localizable.appLanguageLanguageDescriptionEnglish()
        case .chinese:
            return R.string.localizable.appLanguageLanguageDescriptionChiniese()
        }
    }

    // MARK: - Static Properties

    static func save(item: String) -> LanguageItems {
        switch item {
        case R.string.localizable.appLanguageLanguageDescriptionRussian():
            return LanguageItems.russian
        case R.string.localizable.appLanguageLanguageDescriptionSystem():
            return LanguageItems.system
        case R.string.localizable.appLanguageLanguageDescriptionFrench():
            return LanguageItems.french
        case R.string.localizable.appLanguageLanguageDescriptionSpanish():
            return LanguageItems.spanish
        case R.string.localizable.appLanguageLanguageDescriptionArabic():
            return LanguageItems.arabic
        case R.string.localizable.appLanguageLanguageDescriptionGerman():
            return LanguageItems.german
        case R.string.localizable.appLanguageLanguageDescriptionEnglish():
            return LanguageItems.english
        case R.string.localizable.appLanguageLanguageDescriptionChiniese():
            return LanguageItems.chinese
        default:
            return LanguageItems.system
        }
    }
}

// MARK: - LanguageItem

struct LanguageItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var language: LanguageItems

}
