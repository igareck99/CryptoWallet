import Foundation
import Combine

// MARK: - ChannelNotificationsViewModel

final class ChannelNotificationsViewModel: ObservableObject {

    // MARK: - Internal Properties

    var roomId: String

    // MARK: - Private Properties

    private let pushNotification: PushNotificationsServiceProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private let matrixUseCase: MatrixUseCaseProtocol

    // MARK: - Lifecycle

    init(
        roomId: String,
        pushNotification: PushNotificationsServiceProtocol = PushNotificationsService.shared,
        userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared
    ) {
        self.roomId = roomId
        self.pushNotification = pushNotification
        self.userSettings = userSettings
        self.matrixUseCase = matrixUseCase
    }

    // MARK: - Internal Methods

    func computeOpacity(_ item: ChannelNotificationsStatus) -> Double {
        guard let room = matrixUseCase.rooms.first(where: { $0.room.roomId == roomId }) else {  return 0 }
        if !room.room.isMuted && item == .turned || room.room.isMuted && item == .offed {
            return 1
        }
        return 0
    }

    func updateNotifications(_ item: ChannelNotificationsStatus) {
        guard let room = matrixUseCase.rooms.first(where: { $0.room.roomId == roomId }) else {  return }
        if item == .turned {
            if room.room.isMuted && userSettings.isRoomNotificationsEnable {
                pushNotification.allMessages(room: room) { _ in
                }
            }
        }
        if item == .offed {
            pushNotification.mute(room: room) { _ in
            }
        } 
        self.objectWillChange.send()
    }
}

// MARK: - ChannelNotificationsStatus

enum ChannelNotificationsStatus: String, CaseIterable {

    case turned = "Включены"
    case offed = "Отключены"

}
