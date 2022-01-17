import SwiftUI

// MARK: - TypographyItemCase

enum ThemeNewItemCase: Codable {

    // MARK: - Types

    case system
    case light
    case dark

    // MARK: - Internal Properties

    var name: String {
        switch self {
        case .system:
            return R.string.localizable.personalizationSystem()
        case .light:
            return R.string.localizable.personalizationLight()
        case .dark:
            return R.string.localizable.personalizationDark()
        }
    }
    
    // MARK: - Static Properties

    static func save(item: String) -> ThemeNewItemCase {
        switch item {
        case R.string.localizable.personalizationSystem():
            return ThemeNewItemCase.system
        case R.string.localizable.personalizationLight():
            return ThemeNewItemCase.light
        case R.string.localizable.personalizationDark():
            return ThemeNewItemCase.dark
        default:
            return ThemeNewItemCase.system
        }
    }
}

// MARK: - ThemeNewItem

struct ThemeNewItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var title: ThemeNewItemCase
}
