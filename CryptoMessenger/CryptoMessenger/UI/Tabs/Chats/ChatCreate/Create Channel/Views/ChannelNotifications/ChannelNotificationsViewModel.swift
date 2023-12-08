import Foundation
import Combine

// MARK: - ChannelNotificationsViewModel

final class ChannelNotificationsViewModel: ObservableObject {

    // MARK: - Internal Properties

    var roomId: String
    @Published var notificationsOff = false
    let resouces: ChannelNotificationResourcable.Type

    // MARK: - Private Properties

    private let pushNotification: MXRoomNotificationSettingsService
    private let userSettings: UserCredentialsStorage & UserFlowsStorage
    private let matrixUseCase: MatrixUseCaseProtocol

    // MARK: - Lifecycle

    init(
        roomId: String,
        userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        resouces: ChannelNotificationResourcable.Type = ChannelNotificationResources.self
    ) {
        self.resouces = resouces
        self.roomId = roomId
        self.pushNotification = MXRoomNotificationSettingsService(roomId: self.roomId)
        self.userSettings = userSettings
        self.matrixUseCase = matrixUseCase
        getData()
    }

    func getData() {
        guard let room = matrixUseCase.rooms.first(where: { $0.room.roomId == roomId }) else {  return }
        self.notificationsOff = room.room.isMuted
    }

    // MARK: - Internal Methods

    func computeOpacity(_ item: ChannelNotificationsStatus) -> Double {
        if !notificationsOff && item == .turned || notificationsOff && item == .offed {
            return 1
        }
        return 0
    }

    func updateNotifications(_ item: ChannelNotificationsStatus) {
        guard let room = matrixUseCase.rooms.first(where: { $0.room.roomId == roomId }) else {  return }
        if item == .turned {
            pushNotification.update(state: .all) {
                self.notificationsOff = false
            }
        }
        if item == .offed {
            pushNotification.update(state: .mute) {
                self.notificationsOff = true
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
