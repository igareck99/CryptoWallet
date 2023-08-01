import SwiftUI

// MARK: - ChatHistoryData

struct ChatHistoryData: Identifiable, ViewGeneratable {

    var id = UUID()
    var isChannel: Bool
    var isAdmin: Bool
    var isPinned: Bool
    var isOnline: Bool // MAKE
    var isDirect: Bool // MAKE
    var unreadedEvents: Int = 0 // MAKE
    var lastMessage: MessageType // MAKE
    var lastMessageTime: Date // MAKE
    var roomAvatar: URL? // MAKE
    var roomName: String // MAKE
    var numberUsers: Int // MAKE
    var topic: String // MAKE
    var roomId: String // MAKE
    
    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        ChatHistoryRow(room: self,
                       isFromCurrentUser: true).anyView()
    }
}
