import MatrixSDK
import SwiftUI

// MARK: - MXEventCustomEvent

enum MXEventCustomEvent {

    // MARK: - Types

    case contactInfo

    // MARK: - Internal Properties

    var identifier: String {
        switch self {
        case .contactInfo:
            return "MXMessageTypeContact"
        }
    }
}

// MARK: - MXEventEventKey

enum MXEventEventKey: String {

    // MARK: - Types

    case messageType = "msgtype"
    case url
    case body
    case avatar
    case name
    case phone
    case newContent = "m.new_content"
    case eventId = "event_id"
    case relatesTo = "m.relates_to"
    case replyTo = "m.in_reply_to"
}

// MARK: - Dictionary (ExpressibleByStringLiteral)

extension Dictionary where Key: ExpressibleByStringLiteral {

    // MARK: - Subscript

    subscript(_ eventKey: MXEventEventKey) -> Value? {
        get {
            guard let key = eventKey.rawValue as? Key else { return nil }
            return self[key]
        }
        set {
            guard let key = eventKey.rawValue as? Key else { return }
            self[key] = newValue
        }
    }
}

// MARK: - MXEvent ()

extension MXEvent {

    // MARK: - Internal Properties

    var messageType: MessageType {
        let messageType = content[.messageType] as? String
        var type: MessageType

        switch messageType {
        case kMXMessageTypeText:
            if isReply() {
                let reply = MXReplyEventParser().parse(self)
                type = .text(reply.bodyParts.replyText)
            } else if isEdit() {
                type = .none
            } else {
                type = .text(text)
            }
        case kMXMessageTypeImage:
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            let link = content[.url] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .image(url)
        case kMXMessageTypeFile:
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            let link = content[.url] as? String ?? ""
            let fileName = content[.body] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .file(fileName, url)
        case MXEventCustomEvent.contactInfo.identifier:
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            let link = content[.avatar] as? String ?? ""
            let name = content[.name] as? String ?? ""
            let phone = content[.phone] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .contact(name: name, phone: phone, url: url)
        default:
            type = .none
        }

        return type
    }

    var timestamp: Date { Date(timeIntervalSince1970: TimeInterval(originServerTs / 1000)) }

    var text: String {
        if !isEdit() {
            return (content[.body] as? String).map {
                $0
                    .trimmingCharacters(in: .controlCharacters)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } ?? "Error: expected string body"
        } else {
            let newContent = content[.newContent] as? NSDictionary
            return (newContent?[MXEventEventKey.body] as? String).map {
                $0
                    .trimmingCharacters(in: .controlCharacters)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } ?? "Error: expected string body"
        }
    }

    var replyDescription: String {
        let startIndex = text.index(text.lastIndex(of: ">") ?? text.startIndex, offsetBy: 2)
        return String(text.suffix(from: startIndex))
    }

    // MARK: - Internal Methods

    func content<T>(valueFor key: String) -> T? { content?[key] as? T }

    func prevContent<T>(valueFor key: String) -> T? { unsignedData?.prevContent?[key] as? T }

    func message(_ isFromCurrentUser: Bool) -> RoomMessage? {
        switch eventType {
        case .roomMessage:
            return rowItem(isFromCurrentUser)
        default:
            return nil
        }
    }

    // MARK: - Private Methods

    private func rowItem(_ isFromCurrentUser: Bool) -> RoomMessage {
        .init(
            id: eventId,
            type: messageType,
            shortDate: timestamp.hoursAndMinutes,
            fullDate: timestamp.dayOfWeekDayAndMonth,
            isCurrentUser: isFromCurrentUser,
            isReply: isReply(),
            replyDescription: replyDescription
        )
    }
}
