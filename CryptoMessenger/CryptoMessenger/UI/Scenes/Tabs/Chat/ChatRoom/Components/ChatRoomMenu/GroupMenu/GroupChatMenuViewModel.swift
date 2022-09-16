import Foundation

// MARK: - GroupChatMenuViewModel

final class GroupChatMenuViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var actions: [GroupAction] = []

    // MARK: - Private Properties

    private let availabilityFacade: MenuActionsTogglesFacadeProtocol

    // MARK: - Lifecycle

    init(availabilityFacade: MenuActionsTogglesFacadeProtocol = MenuActionsFacadeAssembly.build()) {
        self.availabilityFacade = availabilityFacade
        getActions()
    }

    private func getActions() {
        for action in GroupAction.allCases {
            switch action {
            case .edit:
                if availabilityFacade.isChatMenuEditAvailable {
                    actions.append(action)
                }
            case .notifications :
                if availabilityFacade.isChatMenuNotificationsAvailable {
                    actions.append(action)
                }
            case .search:
                if availabilityFacade.isChatMenuMediaAvailable {
                    actions.append(action)
                }
            case .users:
                if availabilityFacade.isChatMenuUsersAvailable {
                    actions.append(action)
                }
            case .share:
                if availabilityFacade.isChatMenuShareChatAvailable {
                    actions.append(action)
                }
            case .blacklist:
                if availabilityFacade.isChatMenuBlackListAvailable {
                    actions.append(action)
                }
            case .delete:
                if availabilityFacade.isChatMenuNotificationsAvailable {
                    actions.append(action)
                }
            case .translate:
                if availabilityFacade.isChatMenuTranslateAvailable {
                    actions.append(action)
                }
            }
        }
    }
}
