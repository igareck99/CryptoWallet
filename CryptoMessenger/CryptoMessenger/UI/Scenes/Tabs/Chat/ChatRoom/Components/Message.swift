import UIKit

// MARK: - MessageType

enum MessageType {

    // MARK: - Types

    case text(String)
    case image(UIImage)
    case location((lat: Double, long: Double))
    case contact
}

// MARK: - MessageStatus

enum MessageStatus: Hashable {

    // MARK: - Types

    case online
    case offline

    // MARK: - Internal Properties

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

struct Message: Identifiable {

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

// MARK: - Message (Equatable)

extension Message: Equatable {

    // MARK: - Static Methods

    static func == (lhs: Message, rhs: Message) -> Bool { lhs.id == rhs.id }
}

// MARK: - RoomMessage

struct RoomMessage: Identifiable {

    // MARK: - Internal Properties

    let id: String
    let type: MessageType
    let date: String
    let isCurrentUser: Bool
    var reactions: [Reaction] = []
}

// MARK: - RoomMessage (Equatable)

extension RoomMessage: Equatable {

    // MARK: - Static Methods

    static func == (lhs: RoomMessage, rhs: RoomMessage) -> Bool { lhs.id == rhs.id }
}
