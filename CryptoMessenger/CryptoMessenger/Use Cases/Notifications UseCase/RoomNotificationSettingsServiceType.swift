import Foundation

typealias UpdateRoomNotificationStateCompletion = () -> Void
typealias RoomNotificationStateCallback = (RoomNotificationState) -> Void

protocol RoomNotificationSettingsServiceType {
    func observeNotificationState(listener: @escaping RoomNotificationStateCallback)
    func update(state: RoomNotificationState, completion: @escaping UpdateRoomNotificationStateCompletion)
    func getNotificationsOnAllDeviceState() -> Bool?
    var notificationState: RoomNotificationState { get }
}
