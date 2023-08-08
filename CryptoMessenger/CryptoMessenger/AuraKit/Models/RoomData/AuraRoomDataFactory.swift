import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol AuraRoomDataFactoryProtocol {

    func makeChatHistoryRooms(mxRooms: [MXEvent]?) -> [RoomEvent]
}

struct AuraRoomDataFactory {}

// MARK: - AuraRoomObjectFactoryProtocol

extension AuraRoomDataFactory: AuraRoomDataFactoryProtocol {
    
    func makeChatHistoryRooms(mxRooms: [MXEvent]?) -> [RoomEvent] {
        guard let rooms = mxRooms else { return [] }
        let events: [RoomEvent] = rooms
            .map { mxRoom in
                let value = RoomEvent(eventId: mxRoom.eventId, roomId: mxRoom.roomId,
                                      sender: mxRoom.sender, sentState: .sent,
                                     eventType: mxRoom.messageType)
                return value
            }
            .compactMap { $0 }
        return events
    }
}
