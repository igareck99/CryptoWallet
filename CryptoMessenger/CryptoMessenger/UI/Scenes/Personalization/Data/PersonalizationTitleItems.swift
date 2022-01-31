import SwiftUI

// MARK: - PersonalizationTitleCase

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
            return R.string.localizable.personalizationTitleLanguage()
        case .theme:
            return R.string.localizable.personalizationTitleTheme()
        case .backGround:
            return R.string.localizable.personalizationTitleBackground()
        case .typography:
            return R.string.localizable.personalizationTitleTypography()
        }
    }
}

// MARK: - PersonalizationTitleItem

struct PersonalitionTitleItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var title: PersonalizationTitleCase
}
