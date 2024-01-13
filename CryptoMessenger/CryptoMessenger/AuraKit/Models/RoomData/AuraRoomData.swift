import SwiftUI
import MatrixSDK

// MARK: - AuraRoomData

struct AuraRoomData: Identifiable {
    var id = UUID()
    var isChannel: Bool
    var isAdmin: Bool
    var isPinned: Bool
    var isOnline: Bool
    var isDirect: Bool
    var unreadedEvents: Int = 0
    var lastMessage: MessageType
    var lastMessageTime: Date
    var roomAvatar: URL?
    var roomName: String
    var numberUsers: Int
    var topic: String
    var roomId: String
    var roomEvents: [RoomEvent]
    var eventCollections: EventCollection
    var participants: [ChannelParticipantsData]

    var eventCache = [MXEvent]()
    var room: MXRoom

    mutating func events() -> EventCollection {
        if !room.outgoingMessages().isEmpty {
            for item in room.outgoingMessages() {
                guard !eventCache.contains(item) else { continue }
                eventCache.append(item)
            }
        }
        return EventCollection(eventCache)
    }
    
    mutating func add(
        event: MXEvent,
        direction: MXTimelineDirection,
        roomState: MXRoomState?
    ) {
        switch direction {
            case .backwards:
                eventCache.insert(event, at: 0)
            case .forwards:
                eventCache.append(event)
            default:
                break
        }
    }
}
