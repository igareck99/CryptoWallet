import UIKit

// MARK: - MessageType

enum MessageType {
    case text(String)
    case image(UIImage)
    case location((lat: Double, long: Double))
}

// MARK: - MessageStatus

enum MessageStatus: Hashable {
    case online
    case offline

    var color: Palette {
        switch self {
        case .online:
            return .green()
        case .offline:
            return .gray()
        }
    }
}

// MARK: - Message

struct Message: Identifiable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool { lhs.id == rhs.id }

    // MARK: - Internal Properties

    let id = UUID().uuidString
    let type: MessageType
    let status: MessageStatus
    let name: String
    let avatar: UIImage?
    let date: String
    let unreadCount: Int
    var isPinned = false
}

// MARK: - RoomMessage

struct RoomMessage: Identifiable, Equatable {
    static func == (lhs: RoomMessage, rhs: RoomMessage) -> Bool { lhs.id == rhs.id }

    // MARK: - Internal Properties

    let id = UUID().uuidString
    let type: MessageType
    let date: String
    let isCurrentUser: Bool
    var reactions: [Reaction] = []
}
