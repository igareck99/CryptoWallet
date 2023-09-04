import SwiftUI

// MARK: - GroupAction

enum GroupAction: CaseIterable, Identifiable {

    // MARK: - Types

    case edit
    case notifications
    case translate
    case search
    case users
    case share
    case blacklist
    case delete

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var title: String {
        switch self {
        case .edit:
            return R.string.localizable.chatMenuViewEdit()
        case .notifications:
            return R.string.localizable.chatMenuViewNotificationsOff()
        case .translate:
            return R.string.localizable.chatMenuViewTranslate()
        case .search:
            return R.string.localizable.chatMenuViewSearch()
        case .users:
            return R.string.localizable.chatMenuViewUsers()
        case .share:
            return R.string.localizable.chatMenuViewShareChat()
        case .blacklist:
            return R.string.localizable.chatMenuViewBlackList()
        case .delete:
            return R.string.localizable.chatMenuViewRemoveChat()
        }
    }

    var color: Color { self == .delete || self == .blacklist ? .spanishCrimson : .dodgerBlue }

    var image: Image {
        switch self {
        case .edit:
            return R.image.chat.groupMenu.edit.image
        case .notifications:
            return R.image.chat.groupMenu.notifications.image
        case .translate:
            return R.image.chat.groupMenu.translate.image
        case .search:
            return R.image.chat.groupMenu.search.image
        case .users:
            return R.image.chat.groupMenu.users.image
        case .share:
            return R.image.chat.groupMenu.share.image
        case .blacklist:
            return R.image.chat.groupMenu.blackList.image
        case .delete:
            return R.image.chat.groupMenu.delete.image
        }
    }
}
