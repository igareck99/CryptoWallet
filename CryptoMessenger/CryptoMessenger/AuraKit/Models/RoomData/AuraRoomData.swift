import SwiftUI

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
    var events: [RoomEvent]
}
