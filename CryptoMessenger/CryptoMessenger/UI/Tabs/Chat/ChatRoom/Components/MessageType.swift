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
