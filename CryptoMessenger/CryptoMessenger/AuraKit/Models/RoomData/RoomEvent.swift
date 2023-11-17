import Foundation

// MARK: - RoomEvent

struct RoomEvent: Equatable {
    static func == (lhs: RoomEvent, rhs: RoomEvent) -> Bool {
        lhs.roomId == rhs.roomId && lhs.eventId == rhs.eventId
        && NSDictionary(dictionary: lhs.content).isEqual(to: rhs.content)
        && lhs.sentState == rhs.sentState 
    }

    // MARK: - Internal Properties

    let eventId: String
    let roomId: String
    let sender: String
    let senderAvatar: URL?
    var sentState: RoomSentState
    let eventType: MessageType
    let shortDate: String
    let fullDate: String
    let isFromCurrentUser: Bool
    let isReply: Bool
    let reactions: [Reaction]
    let content: [String: Any]
    let eventSubType: String
    let videoThumbnail: URL?

    // MARK: - Lifecycle

    init(
        eventId: String,
        roomId: String,
        sender: String,
        sentState: RoomSentState,
        eventType: MessageType,
        shortDate: String,
        fullDate: String,
        isFromCurrentUser: Bool,
        isReply: Bool,
        reactions: [Reaction],
        content: [String: Any],
        eventSubType: String,
        senderAvatar: URL? = nil,
        videoThumbnail: URL? = nil
    ) {
        self.eventId = eventId
        self.roomId = roomId
        self.sender = sender
        self.senderAvatar = senderAvatar
        self.sentState = sentState
        self.eventType = eventType
        self.shortDate = shortDate
        self.fullDate = fullDate
        self.isFromCurrentUser = isFromCurrentUser
        self.isReply = isReply
        self.eventSubType = eventSubType
        self.reactions = reactions
        self.content = content
        self.videoThumbnail = videoThumbnail
    }
}

extension RoomEvent {

    var audioDuration: String {
        var data = content["info"] as? [String: Any]
        let msc = content["org.matrix.msc1767.audio"] as? [String: Any]
        if msc != nil {
            data = msc
        }
        if data != nil {
            let duration = data?["duration"] as? Int ?? 0
            let time = intToDate(duration)
            return time
        } else {
            return ""
        }
    }

    var dataSize: Int {
        guard let data = content["info"] as? [String: Any] else { return 0 }
        guard let size = data["size"] as? Int else { return 0 }
        return size
    }

    var videoSize: Int {
        guard let data = content["info"] as? [String: Any] else { return 0 }
        guard let info = data["thumbnail_info"] as? [String: Any] else { return 0 }
        guard let size = info["size"] as? Int else { return 0 }
        return size
    }

    var rootEventId: String {
        guard let data = content["m.reply_to"] as? [String: Any] else { return "" }
        guard let text = data["root_event_id"] as? String else { return "" }
        return text
    }

    var contactMxId: String {
        guard let text = content["mxId"] as? String else { return "" }
        return text
    }
}
