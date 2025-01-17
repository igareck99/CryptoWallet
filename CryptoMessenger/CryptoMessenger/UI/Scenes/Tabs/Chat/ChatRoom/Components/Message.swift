import UIKit

// MARK: - MessageType

enum MessageType {

    // MARK: - Types

    case text(String)
    case image(URL?)
    case video(URL?)
    case file(String, URL?)
    case audio(URL?)
    case location((lat: Double, long: Double))
    case contact(name: String, phone: String?, url: URL?)
    case call
    case none
}

// MARK: - Reply

struct Reply {

    // MARK: - Internal Properties

    let user: String
    var text: String
    let replyText: String
}

// MARK: - MessageStatus

enum MessageStatus: Hashable {

    // MARK: - Types

    case online, offline

    // MARK: - Internal Properties

    var color: Palette { self == .online ? .green() : .gray() }
}

// MARK: - Message

struct Message: Identifiable {

    // MARK: - Internal Properties

    let id = UUID().uuidString
    var type: MessageType
    let status: MessageStatus
    let name: String
    let avatar: UIImage?
    let date: String
    let unreadCount: Int
    var isPinned = false
}

// MARK: - Message (Equatable)

extension Message: Equatable {

    // MARK: - Static Methods

    static func == (lhs: Message, rhs: Message) -> Bool { lhs.id == rhs.id }
}

// MARK: - RoomMessage

struct RoomMessage: Identifiable {

    // MARK: - Internal Properties

    let id: String
	let sender: String
    var type: MessageType
    let shortDate: String
    let fullDate: String
    let isCurrentUser: Bool
    let isReply: Bool
    var replyDescription = ""
    var audioDuration = ""
    var eventId = ""
    var name = ""
    var avatar: URL?
    var videoThumbnail: URL?
    var reactions: [Reaction] = []
	// TODO: Удалить эти поля (content, eventType), нужно только для того чтобы убрать из слоя view модель MXEvent
	let content: [String: Any]
	let eventType: String
    var description: String {
        switch type {
        case let .text(text):
            return text
        case .file:
            return "Файл"
        case .image:
            return "Фото"
        case .location:
            return "Местоположение"
        case .contact:
            return "Контакт"
        case .video:
            return "Видео"
        default:
            return "-"
        }
    }
}

// MARK: - CallMessageType

enum CallMessageType: String {

    // MARK: - Internal Properties

    case hangup = "Исходящий звонок"
    case reject = "Входящий звонок"

}

// MARK: - RoomMessage (Equatable)

extension RoomMessage: Equatable {

    // MARK: - Static Methods

    static func == (lhs: RoomMessage, rhs: RoomMessage) -> Bool { lhs.id == rhs.id }
}
