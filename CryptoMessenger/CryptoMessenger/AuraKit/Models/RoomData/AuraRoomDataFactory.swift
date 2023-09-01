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
            .map { mxRoom in
                let value = RoomEvent(
                    eventId: mxRoom.eventId,
                    roomId: mxRoom.roomId,
                    sender: mxRoom.sender,
                    sentState: .sent,
                    eventType: mxRoom.messageType,
                    shortDate: mxRoom.timestamp.hoursAndMinutes,
                    fullDate: mxRoom.timestamp.dayAndMonthAndYear,
                    isFromCurrentUser: mxRoom.sender == matrixUseCase.getUserId()
                )
                return value
            }
            .compactMap { $0 }
        return events
    }
}
