import Foundation
import Combine

// MARK: - DirectChatMenuViewModel

final class DirectChatMenuViewModel: ObservableObject {

    // MARK: - Internal Properties

    let room: AuraRoom
    @Published var actions: [DirectAction] = []

    // MARK: - Private Properties

    private var subscriptions = Set<AnyCancellable>()
    private let eventSubject = PassthroughSubject<AuraRoom, Never>()
    private let availabilityFacade: MenuActionsTogglesFacadeProtocol
    private let pushNotifications: PushNotificationsServiceProtocol

    // MARK: - Lifecycle

    init(room: AuraRoom,
         availabilityFacade: MenuActionsTogglesFacadeProtocol = MenuActionsFacadeAssembly.build(),
         pushNotifications: PushNotificationsServiceProtocol = PushNotificationsService.shared) {
        self.room = room
        self.availabilityFacade = availabilityFacade
        self.pushNotifications = pushNotifications
        getActions()
    }

    // MARK: - Private Properties

    private func getActions() {
        for action in DirectAction.allCases {
            switch action {
            case .notifications:
                if availabilityFacade.isChatMenuNotificationsAvailable {
                    if !room.room.isMuted {
                        actions.append(action)
                    }
                }
            case .notificationsOff:
                if availabilityFacade.isChatMenuNotificationsAvailable {
                    if room.room.isMuted {
                        actions.append(action)
                    }
                }
            case .translate:
                if availabilityFacade.isChatMenuTranslateAvailable {
                    actions.append(action)
                }
            case .media:
                if availabilityFacade.isChatMenuMediaAvailable {
                    actions.append(action)
                }
            case .shareContact:
                if availabilityFacade.isChatMenuShareContactAvailable {
                    actions.append(action)
                }
            case .background:
                if availabilityFacade.isChatMenuBackgroundAvailable {
                    actions.append(action)
                }
            case .clearHistory:
                if availabilityFacade.isChatMenuClearHistoryAvailable {
                    actions.append(action)
                }
            case .blockUser:
                if availabilityFacade.isChatMenuBlockUserAvailable {
                    actions.append(action)
                }
            case .delete:
                if availabilityFacade.isChatMenuNotificationsAvailable {
                    actions.append(action)
                }
            }
        }
    }

    func updateNotifications() {
        if room.room.isMuted {
            pushNotifications.allMessages(room: room) { value in
                self.updateView()
            }
        } else {
            pushNotifications.mute(room: room) { value in
                self.updateView()
            }
        }
    }

    func updateView() {
        if let row = self.actions.firstIndex(where: { $0 == .notifications }), room.room.isMuted {
            actions[row] = .notificationsOff
            return
        }
        if let row = self.actions.firstIndex(where: { $0 == .notificationsOff }), !room.room.isMuted {
            actions[row] = .notifications
            return
        }
        self.objectWillChange.send()
    }
}
