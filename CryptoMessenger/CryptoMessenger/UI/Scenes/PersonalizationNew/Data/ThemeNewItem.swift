import SwiftUI

// MARK: - ThemeItemCase

enum ThemeItemCase: Codable {

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

    static func save(item: String) -> ThemeItemCase {
        switch item {
        case R.string.localizable.personalizationSystem():
            return ThemeItemCase.system
        case R.string.localizable.personalizationLight():
            return ThemeItemCase.light
        case R.string.localizable.personalizationDark():
            return ThemeItemCase.dark
        default:
            return ThemeItemCase.system
        }
    }
}

// MARK: - ThemeItem

struct ThemeItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var title: ThemeItemCase
}
