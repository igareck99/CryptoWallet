import SwiftUI

// MARK: - DirectAction

enum DirectAction: CaseIterable, Identifiable {

    // MARK: - Types

    case notifications
    case notificationsOff
    case translate
    case media
    case shareContact
    case background
    case clearHistory
    case blockUser
    case delete

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var title: String {
        switch self {
        case .notifications:
            return R.string.localizable.chatMenuViewNotificationsTurnOff()
        case .translate:
            return R.string.localizable.chatMenuViewTranslate()
        case .media:
            return R.string.localizable.friendProfileMedia()
        case .shareContact:
            return R.string.localizable.friendProfileShareContact()
        case .background:
            return R.string.localizable.chatMenuViewBackground()
        case .clearHistory:
            return R.string.localizable.chatMenuViewCleatChat()
        case .blockUser:
            return R.string.localizable.chatMenuViewBlockUser()
        case .delete:
            return R.string.localizable.chatMenuViewRemoveChat()
        case .notificationsOff:
            return "Включить уведомления"
        }
    }

    var color: Palette { self == .delete || self == .blockUser || self == .clearHistory ? .red() : .blue() }

    var image: Image {
        switch self {
        case .notifications:
            return R.image.chat.groupMenu.notifications.image
        case .notificationsOff:
            return R.image.chat.groupMenu.notifications.image
        case .translate:
            return R.image.chat.groupMenu.translate.image
        case .media:
            return R.image.chat.groupMenu.media.image
        case .shareContact:
            return R.image.chat.groupMenu.users.image
        case .background:
            return R.image.chat.groupMenu.share.image
        case .clearHistory:
            return R.image.callList.brush.image
        case .blockUser:
            return R.image.chat.groupMenu.blackList.image
        case .delete:
            return R.image.chat.groupMenu.delete.image
        }
    }
}
