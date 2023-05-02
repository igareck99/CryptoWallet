import Foundation

// MARK: - NotificationServiceLogic

final class NotificationServiceLogic {

    let matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared

    func detectEventType(eventId: String, roomId: String) {

        debugPrint("eventId  \(eventId)  roomId \(roomId)")
        guard let room = matrixUseCase.getRoomInfo(roomId: roomId) else { return }
        let auraRoom = AuraRoom(room)
        guard let event = auraRoom.events().renderableEvents.filter({ $0.eventId == eventId }).first else { return }
        switch event.eventType {
        case kMXEventTypeStringRoomMessage:
            print("Пользователь \(event.sender) отправил вам сообщение")
        default:
            break
        }
    }
}
