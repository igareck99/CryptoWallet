import SwiftUI

// MARK: - TypographyItemCase

enum ThemeNewItemCase {

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
}

// MARK: - ThemeNewItem

struct ThemeNewItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var title: ThemeNewItemCase
}
