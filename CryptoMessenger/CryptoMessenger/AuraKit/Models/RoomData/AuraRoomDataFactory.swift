import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol AuraRoomDataFactoryProtocol {

    func makeChatHistoryRooms(
        mxRooms: [MXEvent]?,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [RoomEvent]
}

struct AuraRoomDataFactory {}

// MARK: - AuraRoomObjectFactoryProtocol

extension AuraRoomDataFactory: AuraRoomDataFactoryProtocol {

    func makeChatHistoryRooms(
        mxRooms: [MXEvent]?,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [RoomEvent] {
        guard let rooms = mxRooms else { return [] }
        let events: [RoomEvent] = rooms
            .map { event in
                let value = RoomEvent(
                    eventId: event.eventId,
                    roomId: event.roomId,
                    sender: event.sender,
                    sentState: .sent,
                    eventType: event.messageType,
                    shortDate: event.timestamp.hoursAndMinutes,
                    fullDate: event.timestamp.dayAndMonthAndYear,
                    isFromCurrentUser: event.sender == matrixUseCase.getUserId(),
                    eventSubType: event.type,
                    content: event.content
                )
                return value
            }
            .compactMap { $0 }
        return events
    }
}
