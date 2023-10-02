import Foundation
import MatrixSDK
extension MXEvent {

    // MARK: - Internal Properties

    var messageType: MessageType {
        let messageType = content[.messageType] as? String
        var type: MessageType
        let homeServer = Configuration.shared.matrixURL

        switch messageType {
        case kMXMessageTypeText:
            if isReply() {
                let reply = MXReplyEventParser().parse(self)
                type = .text(reply?.bodyParts.replyText ?? "")
            } else if isEdit() {
                type = .none
            } else {
                type = .text(self.text)
            }
        case kMXMessageTypeVideo:
            if getVideo() {
                let link = content[.url] as? String ?? ""
                let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
                type = .video(url)
            } else {
                type = .none
            }
        case kMXMessageTypeAudio:
            let link = content[.url] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .audio(url)
        case kMXMessageTypeImage:
            let link = content[.url] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .image(url)
        case kMXMessageTypeLocation:
            let latitude = content[.latitude] as? String ?? ""
            let longitude = content[.longitude] as? String ?? ""
            type = .location((lat: Double(latitude) ?? 0, long: Double(longitude) ?? 0))
        case kMXMessageTypeFile:
            let link = content[.url] as? String ?? ""
            let fileName = content[.body] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .file(fileName, url)
        case MXEventCustomEvent.contactInfo.identifier:
            let link = content[.avatar] as? String ?? ""
            let name = content[.name] as? String ?? ""
            let phone = content[.phone] as? String ?? ""
            let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
            type = .contact(name: name, phone: phone, url: url)
        case kMXEventTypeStringCallInvite:
            type = .call
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
    
    private func getVideo() -> Bool {
        return true
    }
}

// MARK: - MXEventEventKey

enum MXEventEventKey: String {

    // MARK: - Types

    case messageType = "msgtype"
    case url
    case latitude
    case longitude
    case body
    case avatar
    case name
    case phone
    case info
    case thumbnailUrl = "thumbnail_url"
    case thumbnailInfo = "thumbnail_info"
    case newContent = "m.new_content"
    case eventId = "event_id"
    case relatesTo = "m.relates_to"
    case inReplyTo = "m.in_reply_to"
    case customContent = "m.reply_to"
    case rootUserId = "root_user_id"
    case rootMessage = "root_message"
    case rootEventId = "root_event_id"
    case rootLink = "root_link"
}

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

struct MXURL {

    // MARK: - Internal Properties

    var mxContentURI: URL

    // MARK: - Life Cycle

    init?(mxContentURI: String) {
        guard let uri = URL(string: mxContentURI) else {
            return nil
        }
        self.mxContentURI = uri
    }

    // MARK: - Internal Methods

    func contentURL(on homeserver: URL) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = homeserver.host
        guard let contentHost = mxContentURI.host else { return nil }
        components.path = "/_matrix/media/r0/download/\(contentHost)/\(mxContentURI.lastPathComponent)"
        return components.url
    }
}

// MARK: - MXEventCustomEvent

enum MXEventCustomEvent {

    // MARK: - Types

    case contactInfo

    // MARK: - Internal Properties

    var identifier: String {
        switch self {
        case .contactInfo:
            return "ms.aura.contact"
        }
    }
}
