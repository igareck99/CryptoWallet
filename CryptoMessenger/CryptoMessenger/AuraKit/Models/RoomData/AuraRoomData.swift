import SwiftUI

// MARK: - AuraRoomData

class AuraRoomData: Identifiable {

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
    var events: [RoomEvent]
    var eventCollections: EventCollection
    var participants: [ChannelParticipantsData]
    
    init(id: UUID = UUID(), isChannel: Bool, isAdmin: Bool,
         isPinned: Bool, isOnline: Bool, isDirect: Bool,
         unreadedEvents: Int, lastMessage: MessageType,
         lastMessageTime: Date, roomAvatar: URL? = nil,
         roomName: String, numberUsers: Int, topic: String,
         roomId: String, events: [RoomEvent],
         eventCollections: EventCollection,
         participants: [ChannelParticipantsData]) {
        self.id = id
        self.isChannel = isChannel
        self.isAdmin = isAdmin
        self.isPinned = isPinned
        self.isOnline = isOnline
        self.isDirect = isDirect
        self.unreadedEvents = unreadedEvents
        self.lastMessage = lastMessage
        self.lastMessageTime = lastMessageTime
        self.roomAvatar = roomAvatar
        self.roomName = roomName
        self.numberUsers = numberUsers
        self.topic = topic
        self.roomId = roomId
        self.events = events
        self.eventCollections = eventCollections
        self.participants = participants
    }
}
