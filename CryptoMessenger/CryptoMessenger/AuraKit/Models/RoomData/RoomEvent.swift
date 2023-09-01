import Foundation
import MatrixSDK

// MARK: - RoomEvent

struct RoomEvent {

    // MARK: - Internal Properties

    var eventId: String
    var roomId: String
    var sender: String
    var senderAvatar: URL?
    var sentState: RoomSentState
    var eventType: MessageType
    var shortDate: String
    var fullDate: String
    var isFromCurrentUser: Bool
    var reactions: [ReactionTextItem]
//    let content: [String: Any]
//    let eventType: String

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
        reactions: [ReactionTextItem] = [],
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
        self.reactions = reactions
    }
}
