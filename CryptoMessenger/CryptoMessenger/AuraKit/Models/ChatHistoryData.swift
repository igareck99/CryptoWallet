import SwiftUI

// MARK: - ChatHistoryData

struct ChatHistoryData: Identifiable, ViewGeneratable {

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
    var onTap: (ChatHistoryData) -> Void
    var onLongPress: (ChatHistoryData) -> Void

    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        ChatHistoryRow(room: self,
                       isFromCurrentUser: true).anyView()
    }
}
