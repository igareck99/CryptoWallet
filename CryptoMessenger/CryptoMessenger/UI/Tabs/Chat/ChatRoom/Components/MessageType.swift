import UIKit

// MARK: - MessageType

enum MessageType {

    // MARK: - Types

    // message types
    case text(String)
    case image(URL?)
    case video(URL?)
    case file(String, URL?)
    case audio(URL?)
    case location((lat: Double, long: Double))
    case contact(name: String, phone: String?, url: URL?)

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
