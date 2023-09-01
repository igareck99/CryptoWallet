import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol RoomEventObjectFactoryProtocol {

    func makeChatHistoryRoomEvents(
        events: [MXEvent]?,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [RoomEvent]
}

struct RoomEventObjectFactory {}

// MARK: - RoomDataObjectFactory(RoomEventObjectFactoryFactoryProtocol)

extension RoomEventObjectFactory: RoomEventObjectFactoryProtocol {
    
    func makeChatHistoryRoomEvents(
        events: [MXEvent]?,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [RoomEvent] {
        guard let roomEvents = events else { return [] }
        let events: [RoomEvent] = roomEvents
            .map { event in
                var url: URL?
                let isFromCurrentUser = event.sender == matrixUseCase.getUserId()
                let group = DispatchGroup()
                group.enter()
                if !isFromCurrentUser {
                    // закоментировал т.к. почему-то бомбардирует сервер запросами на загрузку аватарок
//                    matrixUseCase.avatarUrlForUser(mxRoom.sender) { value in
//                        url = value
//                    }
                }
                let value = RoomEvent(
                    eventId: event.eventId,
                    roomId: event.roomId,
                    sender: event.sender,
                    sentState: .sent,
                    eventType: event.messageType,
                    shortDate: event.timestamp.hoursAndMinutes,
                    fullDate: event.timestamp.dayAndMonthAndYear,
                    isFromCurrentUser: event.sender == matrixUseCase.getUserId()
                )
                return value
            }
            .compactMap { $0 }
        return events
    }
}
