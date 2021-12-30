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

// MARK: - PersonalizationTitleItem

struct PersonalitionTitleItem: Identifiable {

    // MARK: - Internal Properties

    var id = UUID()
    var title: PersonalizationTitleCase
}
