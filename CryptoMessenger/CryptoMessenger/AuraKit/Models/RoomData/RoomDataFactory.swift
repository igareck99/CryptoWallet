import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol RoomEventObjectFactoryProtocol {

    func makeChatHistoryRoomEvents(
        eventCollections: EventCollection,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [RoomEvent]
}

struct RoomEventObjectFactory {}

// MARK: - RoomDataObjectFactory(RoomEventObjectFactoryFactoryProtocol)

extension RoomEventObjectFactory: RoomEventObjectFactoryProtocol {
    
    func makeChatHistoryRoomEvents(
        eventCollections: EventCollection,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [RoomEvent] {
        let roomEvents = eventCollections.wrapped
        let events: [RoomEvent] = roomEvents
            .map { event in
                var url: URL?
                var reactions: [Reaction] = []
                let isFromCurrentUser = event.sender == matrixUseCase.getUserId()
                reactions = eventCollections.reactions(for: event)
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
                    isFromCurrentUser: event.sender == matrixUseCase.getUserId(),
                    isReply: event.isReply(),
                    replyDescription: event.replyDescription,
                    reactions: reactions,
                    content: event.content
                )
                return value
            }
            .compactMap { $0 }
        return events
    }
}
