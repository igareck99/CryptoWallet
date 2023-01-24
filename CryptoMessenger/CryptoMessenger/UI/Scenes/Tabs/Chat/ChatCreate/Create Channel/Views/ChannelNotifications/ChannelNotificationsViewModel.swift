import Foundation
import Combine

// MARK: - ChannelNotificationsViewModel

final class ChannelNotificationsViewModel: ObservableObject {
    
    // MARK: - Private Properties

    private let pushNotification: PushNotificationsServiceProtocol
    @Published var isNotificationsTurned = false

    // MARK: - Lifecycle

    init(
        pushNotification: PushNotificationsServiceProtocol = PushNotificationsService.shared
    ) {
        self.pushNotification = pushNotification
    }

    // MARK: - Internal Methods
    
    func toggleStateNotification(_ value: Bool) {
        isNotificationsTurned = value
    }

    func computeOpacity(_ item: ChannelNotificationsStatus) -> Double {
        if isNotificationsTurned && item == .turned || !isNotificationsTurned && item == .offed {
            return 1
        }
        return 0
    }
}

// MARK: - ChannelNotificationsStatus

enum ChannelNotificationsStatus: String, CaseIterable {

    case turned = "Включены"
    case offed = "Отключены"

}
