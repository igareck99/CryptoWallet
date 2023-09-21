import Foundation

// MARK: - RoomEvent

struct RoomEvent {

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
    let replyDescription: String
    let reactions: [Reaction]
    let content: [String: Any]
    let eventSubType: String

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
        replyDescription: String,
        reactions: [Reaction],
        content: [String: Any],
        eventSubType: String,
        senderAvatar: URL? = nil
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
        self.replyDescription = replyDescription
        self.eventSubType = eventSubType
        self.reactions = reactions
        self.content = content
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
}
