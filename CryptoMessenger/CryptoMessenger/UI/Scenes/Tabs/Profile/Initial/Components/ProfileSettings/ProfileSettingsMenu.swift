import SwiftUI

// MARK: - ProfileSettingsMenu

enum ProfileSettingsMenu: CaseIterable, Identifiable {

    // MARK: - Types

    case profile, personalization, security, wallet, notifications
    case chat, storage, questions, about

    // MARK: - Internal Properties

    var id: UUID { UUID() }
    var result: (title: String, image: Image) {
        let strings = R.string.localizable.self
        let images = R.image.additionalMenu.self
        switch self {
        case .profile:
            return (strings.additionalMenuProfile(), images.profile.image)
        case .personalization:
            return (strings.additionalMenuPersonalization(), images.personalization.image)
        case .security:
            return (strings.additionalMenuSecurity(), images.security.image)
        case .wallet:
            return (strings.additionalMenuWallet(), images.wallet.image)
        case .notifications:
            return (strings.additionalMenuNotification(), images.notifications.image)
        case .chat:
            return (strings.additionalMenuChats(), images.chat.image)
        case .storage:
            return (strings.additionalMenuData(), images.dataStorage.image)
        case .questions:
            return (strings.additionalMenuQuestions(), images.questions.image)
        case .about:
            return (strings.additionalMenuAbout(), images.about.image)
        }
    }
}
