import SwiftUI

// MARK: - MatrixObjectFactoryProtocol

protocol ChatHistoryRowComponentsFactoryProtocol {

    func makeAvatarView(_ avatarUrl: URL?,
                        _ roomName: String,
                        _ isDirect: Bool,
                        _ isOnline: Bool) -> any ViewGeneratable

    func makeLastMessageView(_ messageType: MessageType,
                             _ unreadedEvents: Int,
                             _ isPinned: Bool,
                             _ isFromCurrentUser: Bool) -> any ViewGeneratable

    func makeNameView(_ lastMessageTime: Date,
                      _ roomName: String) -> any ViewGeneratable
}

struct ChatHistoryRowComponentsFactory {}

// MARK: - ChatHistoryRowComponentsFactory(ChatHistoryRowComponentsFactoryProtocol)

extension ChatHistoryRowComponentsFactory: ChatHistoryRowComponentsFactoryProtocol {

    func makeAvatarView(_ avatarUrl: URL?,
                        _ roomName: String,
                        _ isDirect: Bool,
                        _ isOnline: Bool) -> any ViewGeneratable {
        let view = AvatarViewData(
            avatarUrl: avatarUrl,
            roomName: roomName,
            isDirect: isDirect,
            isOnline: isOnline
        )
        return view
    }

    func makeLastMessageView(_ messageType: MessageType,
                             _ unreadedEvents: Int,
                             _ isPinned: Bool,
                             _ isFromCurrentUser: Bool) -> any ViewGeneratable {
        return LastMessageData(messageType: messageType,
                               isFromCurrentUser: isFromCurrentUser,
                               unreadedEvents: unreadedEvents,
                               isPinned: isPinned)
    }

    func makeNameView(_ lastMessageTime: Date,
                      _ roomName: String) -> any ViewGeneratable {
        return NameViewModel(lastMessageTime: lastMessageTime,
                             roomName: roomName)
    }

}
