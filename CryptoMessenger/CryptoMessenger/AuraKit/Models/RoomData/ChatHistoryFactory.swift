import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol ChatHistoryObjectFactoryProtocol {

    func makeChatHistoryRooms(
        mxRooms: [AuraRoomData]?,
        viewModel: any ChatHistoryViewDelegate
    ) -> [ChatHistoryData]

    func makeChatHistoryChannels(
        dataRooms: [ChatHistoryData]?, isJoined: Bool,
        viewModel: any ChatHistoryViewDelegate
    ) -> [MatrixChannel]
}

struct ChatHistoryObjectFactory {
    private let chatRowObjectFactory: ChatHistoryRowComponentsFactoryProtocol = ChatHistoryRowComponentsFactory()
}

// MARK: - RoomDataObjectFactory(ChatHistoryObjectFactoryProtocol)

extension ChatHistoryObjectFactory: ChatHistoryObjectFactoryProtocol {

    func makeChatHistoryRooms(
        mxRooms: [AuraRoomData]?,
        viewModel: any ChatHistoryViewDelegate
    ) -> [ChatHistoryData] {
        guard let rooms = mxRooms else { return [] }
        let chatRooms: [ChatHistoryData] = rooms
            .map { room in
                let avatarView = chatRowObjectFactory.makeAvatarView(
                    room.roomAvatar,
                    room.roomName,
                    room.isDirect,
                    room.isOnline
                )
                let nameView = chatRowObjectFactory.makeNameView(
                    room.lastMessageTime,
                    room.roomName,
                    room.unreadedEvents,
                    room.isPinned
                )
                let messageView = chatRowObjectFactory.makeLastMessageView(
                    room.lastMessage,
                    room.unreadedEvents,
                    room.roomName,
                    true
                )
                let value = ChatHistoryData(
                    isChannel: room.isChannel,
                    isAdmin: room.isAdmin,
                    isPinned: room.isPinned,
                    isOnline: room.isOnline,
                    isDirect: room.isDirect,
                    lastMessage: room.lastMessage,
                    lastMessageTime: room.lastMessageTime,
                    roomName: room.roomName,
                    numberUsers: room.numberUsers,
                    topic: room.topic,
                    roomId: room.roomId,
                    avatarView: avatarView,
                    nameView: nameView,
                    messageView: messageView
                ) { room in
                    viewModel.didTapChat(room)
                } onLongPress: { room in
                    viewModel.didSettingsCall(room)
                }
                return value
            }
//            .compactMap { $0 }
        return chatRooms
    }

    func makeChatHistoryChannels(
        dataRooms: [ChatHistoryData]?, isJoined: Bool,
        viewModel: any ChatHistoryViewDelegate
    ) -> [MatrixChannel] {
        guard let rooms = dataRooms else { return [] }
        let result: [MatrixChannel] = rooms
            .map { room in
                let value = MatrixChannel(
                    roomId: room.roomId,
                    name: room.roomName,
                    numJoinedMembers: room.numberUsers,
                    avatarUrl: room.roomAvatar?.absoluteString ?? "",
                    isJoined: isJoined,
                    onTap: { room in
                        viewModel.didTapFindedCell(room)
                    }
                )
                return value
            }
            .compactMap { $0 }
        return result
    }
}
