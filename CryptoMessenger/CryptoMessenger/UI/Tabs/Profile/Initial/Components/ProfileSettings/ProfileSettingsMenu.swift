import SwiftUI

// MARK: - ProfileSettingsMenu

enum ProfileSettingsMenu: CaseIterable, Identifiable {

    // MARK: - Types

    case profile, personalization, security, notifications, about

    // MARK: - Internal Properties

    var id: UUID { UUID() }
    var result: (title: String, image: Image) {
        let strings = R.string.localizable.self
        let images = R.image.additionalMenu.self
        switch self {
        case .profile:
            return (strings.additionalMenuProfile(), images.profileNew.image)
        case .personalization:
            return (strings.additionalMenuPersonalization(), images.personalizationNew.image)
        case .security:
            return (strings.additionalMenuSecurity(), images.securityNew.image)
        case .notifications:
            return (strings.additionalMenuNotification(), images.notificationsNew.image)
        case .about:
            return (strings.additionalMenuAbout(), images.aboutApp.image)
        }
    }
}
