import UIKit

// MARK: - Chat

struct Message {

    // MARK: - Internal Properties

    let type: MessageType
    let status: MessageStatus
    let name: String
    let avatar: UIImage?
    let date: String
    let unreadCount: Int

    // MARK: - MessageType

    enum MessageType {
        case text(String)
        case image(UIImage?)
    }

    // MARK: - MessageStatus

    enum MessageStatus {
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
}
