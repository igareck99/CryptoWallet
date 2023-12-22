import SwiftUI

// MARK: - QuickActionCurrentUser

enum QuickActionCurrentUser: CaseIterable {

    // MARK: - Types

    case reply
    case edit
    case copy
    case addReaction
    case reaction
    case save
    case delete

    // MARK: - Internal Properties

    var title: String {
        switch self {
        case .reply:
            return R.string.localizable.quickMenuAnswer()
        case .edit:
            return R.string.localizable.quickMenuEdit()
        case .copy:
            return "Копировать"
        case .save:
            return "Сохранить"
        case .addReaction:
            return "Добавить реакцию"
        case .reaction:
            return "Посмотреть реакции"
        case .delete:
            return R.string.localizable.quickMenuDelete()
        }
    }

    var color: Color { self == .delete ? .spanishCrimson : .dodgerBlue }

    var image: Image {
        switch self {
        case .reply:
            return R.image.chat.messageMenu.reply.image
        case .copy:
            return R.image.chat.messageMenu.copy.image
        case .edit:
            return R.image.chat.messageMenu.edit.image
        case .save:
            return R.image.chat.messageMenu.save.image
        case .addReaction:
            return R.image.chat.messageMenu.reaction.image
        case .reaction:
            return R.image.chat.messageMenu.reaction.image
        case .delete:
            return R.image.chat.messageMenu.trash.image
        }
    }
}

// MARK: - QiuckMenyViewSize

enum QiuckMenyViewSize {

    case fromCurrentUser
    case fromAnotherUser
    case channel

    static func size(_ isFromCurrentUser: Bool,
                     _ isChannel: Bool,
                     _ channelRole: ChannelRole) -> CGFloat {
        if isChannel {
            switch channelRole {
            case .owner:
                return 393
            case .admin:
                return 336
            case .user:
                return 279
            case .unknown:
                return 0
            }
        } else if isFromCurrentUser && !isChannel {
            return 393
        } else {
            return 279
        }
    }
}
