import Foundation

// MARK: - DirectChatMenuViewModel

final class DirectChatMenuViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var actions: [DirectAction] = []

    // MARK: - Private Properties

    private let availabilityFacade: MenuActionsTogglesFacadeProtocol

    // MARK: - Lifecycle

    init(availabilityFacade: MenuActionsTogglesFacadeProtocol = MenuActionsFacadeAssembly.build()) {
        self.availabilityFacade = availabilityFacade
        getActions()
    }

    private func getActions() {
        for action in DirectAction.allCases {
            switch action {
            case .notifications:
                if availabilityFacade.isChatMenuNotificationsAvailable {
                    actions.append(action)
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
}
