import SwiftUI

// MARK: - ProfileSettingsMenu

enum FriendProfileSettingsMenu: CaseIterable, Identifiable {

    // MARK: - Types

    case notification, shareContact, addContact, media, addNote
    case complain, block

    // MARK: - Internal Properties

    var id: UUID { UUID() }
    var result: (title: String, image: Image) {
        let strings = R.string.localizable.self
        let images = R.image.chat.self
        switch self {
        case .notification:
            return (strings.friendProfileNotifications(), images.groupMenu.notifications.image)
        case .shareContact:
            return (strings.friendProfileShareContact(), images.groupMenu.share.image)
        case .addContact:
            return (strings.friendProfileAddContact(), images.group.contact.image)
        case .media:
            return (strings.friendProfileMedia(), images.groupMenu.media.image)
        case .addNote:
            return (strings.friendProfileNotes(), images.messageMenu.edit.image)
        case .complain:
            return (strings.friendProfileComplain(), images.groupMenu.blackList.image)
        case .block:
            return (strings.friendProfileBlock(), images.groupMenu.blackList.image)
        }
    }
}
