import SwiftUI

// MARK: - ContactInfoSourcesable

protocol ContactInfoSourcesable {
    
    // MARK: - Static Properties

    // Images
    static var avatarImage: Image { get }

    // Text
    static var closeText: String { get }

    static var titleText: String { get }

    static var phoneText: String { get }
}

// MARK: - ContactInfoResources(ContactInfoSourcesable)

enum ContactInfoResources: ContactInfoSourcesable {
    
    // MARK: - Static Properties

    // Images

    static var avatarImage: Image {
        R.image.profile.avatarThumbnail.image
    }

    // Text

    static var closeText: String {
        R.string.localizable.contactChatDetailClose()
    }

    static var titleText: String {
        R.string.localizable.contactChatDetailInfo()
    }

    static var phoneText: String {
        R.string.localizable.contactChatDetailCellPhone()
    }
}
