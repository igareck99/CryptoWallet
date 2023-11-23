import Foundation

// MARK: - RoomEvent

struct RoomEvent: Equatable, Hashable {

    // MARK: - Internal Properties

    let id: UUID
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
    let eventDate: Date
    let eventSubType: String
    let videoThumbnail: URL?

    func hash(into hasher: inout Hasher) {
        let jsonData = try? JSONSerialization.data(withJSONObject: content)
        hasher.combine(eventId)
        hasher.combine(sentState)
        hasher.combine(jsonData)
    }

    static func == (lhs: RoomEvent, rhs: RoomEvent) -> Bool {
        lhs.roomId == rhs.roomId && lhs.eventId == rhs.eventId
        && NSDictionary(dictionary: lhs.content).isEqual(to: rhs.content)
        && lhs.sentState == rhs.sentState
        && lhs.reactions == rhs.reactions
    }

    // MARK: - Lifecycle

    init(
        id: UUID = UUID(),
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
        eventDate: Date,
        senderAvatar: URL? = nil,
        videoThumbnail: URL? = nil
    ) {
        self.id = id
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
        self.eventDate = eventDate
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

    var formattedDate: String {
        let dateStr: String
        if let date: String = content[.date] as? String,
           let timeInterval: TimeInterval = try? TimeInterval(value: date) {
            let date = Date(timeIntervalSince1970: timeInterval)
            dateStr = date.dayAndMonthAndYear
        } else {
            dateStr = Date().dayAndMonthAndYear
        }
        return dateStr
    }
}
