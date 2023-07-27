import Foundation

// MARK: - MenuActionsTogglesFacadeProtocol

protocol MenuActionsTogglesFacadeProtocol {
    var isChatMenuNotificationsAvailable: Bool { get }
    var isChatMenuSearchAvailable: Bool { get }
    var isChatMenuTranslateAvailable: Bool { get }
    var isChatMenuShareChatAvailable: Bool { get }
    var isChatMenuShareContactAvailable: Bool { get }
    var isChatMenuMediaAvailable: Bool { get }
    var isChatMenuBackgroundAvailable: Bool { get }
    var isChatMenuBlockUserAvailable: Bool { get }
    var isChatMenuClearHistoryAvailable: Bool { get }
    var isChatMenuEditAvailable: Bool { get }
    var isChatMenuUsersAvailable: Bool { get }
    var isChatMenuBlackListAvailable: Bool { get }
}

// MARK: - MenuActionsTogglesFacade

final class MenuActionsTogglesFacade {
    private let remoteConfigUseCase: RemoteConfigFacade

    init(remoteConfigUseCase: RemoteConfigFacade) {
        self.remoteConfigUseCase = remoteConfigUseCase
    }
}

// MARK: - MenuActionsTogglesFacade(MenuActionsTogglesFacadeProtocol)

extension MenuActionsTogglesFacade: MenuActionsTogglesFacadeProtocol {

    var isChatMenuSearchAvailable: Bool {
        remoteConfigUseCase.isChatMenuSearchAvailable
    }

    var isChatMenuTranslateAvailable: Bool {
        remoteConfigUseCase.isChatMenuTranslateAvailable
    }

    var isChatMenuShareChatAvailable: Bool {
        remoteConfigUseCase.isChatMenuShareChatAvailable
    }

    var isChatMenuShareContactAvailable: Bool {
        remoteConfigUseCase.isChatMenuShareContactAvailable
    }

    var isChatMenuNotificationsAvailable: Bool {
        remoteConfigUseCase.isChatMenuNotificationsAvailable
    }

    var isChatMenuBlockUserAvailable: Bool {
        remoteConfigUseCase.isChatMenuBlockUserAvailable
    }

    var isChatMenuBackgroundAvailable: Bool {
        remoteConfigUseCase.isChatMenuBackgroundAvailable
    }

    var isChatMenuMediaAvailable: Bool {
        remoteConfigUseCase.isChatMenuMediaAvailable
    }

    var isChatMenuBlackListAvailable: Bool {
        remoteConfigUseCase.isChatMenuBlackListAvailable
    }

    var isChatMenuClearHistoryAvailable: Bool {
        remoteConfigUseCase.isChatMenuClearHistoryAvailable
    }

    var isChatMenuUsersAvailable: Bool {
        remoteConfigUseCase.isChatMenuUsersAvailable
    }

    var isChatMenuEditAvailable: Bool {
        remoteConfigUseCase.isChatMenuEditAvailable
    }
}
