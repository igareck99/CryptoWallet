import UIKit

// MARK: - Chat

struct Message {

    // MARK: - Internal Properties

    let name: String
    let icon: UIImage?
    let message: String
    let date: String
    let status: Status = .online
    let unreadMessagesCount: Int

    // MARK: - Status

    enum Status {
        case online
        case offline

        var color: Palette {
            switch self {
            case .online:
                return .green()
            case .offline:
                return .lightGray()
            }
        }
    }
}
