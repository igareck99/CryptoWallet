import UIKit

// MARK: - MessageType

enum MessageType: Equatable {
    static func == (lhs: MessageType, rhs: MessageType) -> Bool {
        switch (lhs, rhs) {
        case (let .text(lhsString), let .text(rhsString)):
            return lhsString == rhsString
        case (let .image(lhsString), let .image(rhsString)):
            return lhsString == rhsString
        case (let .video(lhsString), let .video(rhsString)):
            return lhsString == rhsString
        case (let .file(lhsString, lhsUrl), let .file(rhsString, rhsUrl)):
            return lhsString == rhsString && lhsUrl == rhsUrl
        case (let .audio(lhsString), let .audio(rhsString)):
            return lhsString == rhsString
        case (let .location(lhsLat, lhsLon), let .location(rhsLat, rhsLon)):
            return lhsLat == rhsLat && rhsLon == lhsLon
        case (let .contact(lhsName, lhsPhone, lhsUrl), let .contact(rhsName, rhsPhone, rhsUrl)):
            return lhsName == rhsName && lhsPhone == rhsPhone && lhsUrl == rhsUrl
        case (let .date(lhs), let .date(rhs)):
            return lhs == rhs
        case (let .groupCall(lhsEventId, lhstext), let .groupCall(rhsEventId, rhstext)):
            return lhsEventId == rhsEventId && lhstext == rhstext
        case (let .encryption(lhsString), let .encryption(rhsString)):
            return lhsString == rhsString
        case (.call, .call), (.date(_),  .date(_)), ( .joinRoom(_),  .joinRoom(_)), ( .leaveRoom(_),  .leaveRoom(_)):
            return true
        default:
            return false
        }
    }

    // MARK: - Types

    // message types
    case text(String)
    case image(URL?)
    case video(URL?)
    case file(String, URL?)
    case audio(URL?)
    case location((lat: Double, long: Double))
    case contact(name: String, phone: String?, url: URL?)
    case sendCrypto

    // system event types
    case call
    case date(String)
    case groupCall(eventId: String, text: String)
    case encryption(String)
    case avatarChange(String)
    case joinRoom(String)
    case leaveRoom(String)
    case inviteToRoom(String)
    case none
}

// MARK: - MessageSendType

enum MessageSendType {
    case text
    case image
    case video
    case file
    case audio
    case location
    case contact
}
