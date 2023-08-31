import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol RoomEventObjectFactoryProtocol {

    func makeChatHistoryRoomEvents(mxRooms: [MXEvent]?,
                                   matrixUseCase: MatrixUseCaseProtocol) -> [RoomEvent]
}

struct RoomEventObjectFactory {}

// MARK: - RoomDataObjectFactory(RoomEventObjectFactoryFactoryProtocol)

extension RoomEventObjectFactory: RoomEventObjectFactoryProtocol {
    
    func makeChatHistoryRoomEvents(mxRooms: [MXEvent]?,
                                   matrixUseCase: MatrixUseCaseProtocol) -> [RoomEvent] {
        guard let rooms = mxRooms else { return [] }
        let events: [RoomEvent] = rooms
            .map { mxRoom in
                var url: URL?
                let isFromCurrentUser = mxRoom.sender == matrixUseCase.getUserId()
                let group = DispatchGroup()
                group.enter()
                if !isFromCurrentUser {
                    matrixUseCase.avatarUrlForUser(mxRoom.sender) { value in
                        url = value
                    }
                }
                let value = RoomEvent(eventId: mxRoom.eventId, roomId: mxRoom.roomId,
                                      sender: mxRoom.sender,
                                      sentState: .sent,
                                      eventType: mxRoom.messageType,
                                      shortDate: mxRoom.timestamp.hoursAndMinutes,
                                      fullDate: mxRoom.timestamp.dayAndMonthAndYear,
                                      isFromCurrentUser: isFromCurrentUser,
                                      senderAvatar: url)
                return value
            }
            .compactMap { $0 }
        return events
    }
}
