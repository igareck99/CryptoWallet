import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol ChatHistoryObjectFactoryProtocol {

    func makeChatHistoryRooms(mxRooms: [AuraRoomData]?) -> [ChatHistoryData]
}

struct ChatHistoryObjectFactory {}

// MARK: - RoomDataObjectFactory(ChatHistoryObjectFactoryProtocol)

extension ChatHistoryObjectFactory: ChatHistoryObjectFactoryProtocol {
    
    func makeChatHistoryRooms(mxRooms: [AuraRoomData]?) -> [ChatHistoryData] {
        guard let rooms = mxRooms else { return [] }
        let chatRooms: [ChatHistoryData] = rooms
            .map { room in
                let value = ChatHistoryData(isChannel: room.isChannel, isAdmin: room.isAdmin,
                                            isPinned: room.isPinned, isOnline: room.isOnline,
                                            isDirect: room.isDirect, lastMessage: room.lastMessage,
                                            lastMessageTime: room.lastMessageTime,
                                            roomName: room.roomName,
                                            numberUsers: room.numberUsers,
                                            topic: room.topic, roomId: room.roomId)
                return value
            }
            .compactMap { $0 }
        return chatRooms
    }
}
