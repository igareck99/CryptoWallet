import Foundation
import MatrixSDK

// MARK: - RoomData

struct RoomEvent {

    // MARK: - Internal Properties

    var eventId: String
    var roomId: String
    var sender: String
    var sentState: RoomSentState
    var eventType: MessageType

    // MARK: - Lifecycle

    init(eventId: String, roomId: String, sender: String,
         sentState: RoomSentState, eventType: MessageType) {
        self.eventId = eventId
        self.roomId = roomId
        self.sender = sender
        self.sentState = sentState
        self.eventType = eventType
    }
}
