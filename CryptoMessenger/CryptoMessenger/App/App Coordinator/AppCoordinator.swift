import UIKit

// swiftlint:disable all

protocol AppCoordinatorProtocol {
	func didReceive(notification: UNNotificationResponse, completion: @escaping () -> Void)
}

final class AppCoordinator {

    var childCoordinators: [String: Coordinator] = [:]
	private(set) var navigationController: UINavigationController

	private var pendingCoordinators = [Coordinator]()
	private let keychainService: KeychainServiceProtocol
    private let router: AppCoordinatorRouterable
    private let factory: CoordinatorsFactoryProtocol.Type
    private let privateDataCleaner: PrivateDataCleanerProtocol
    let userSettings: UserFlowsStorage
    let timeService: AppTimeServiceProtocol

    init(
		keychainService: KeychainServiceProtocol,
        userSettings: UserFlowsStorage,
        router: AppCoordinatorRouterable,
        factory: CoordinatorsFactoryProtocol.Type,
        privateDataCleaner: PrivateDataCleanerProtocol,
        timeService: AppTimeServiceProtocol,
		navigationController: UINavigationController
	) {
		self.keychainService = keychainService
		self.userSettings = userSettings
        self.router = router
        self.factory = factory
        self.privateDataCleaner = privateDataCleaner
        self.timeService = timeService
        self.navigationController = navigationController
    }

	private func showAuthenticationFlow() {
        let authFlowCoordinator = factory.makeAuthCoordinator(
            delegate: self,
            navigationController: navigationController
        )
        addChildCoordinator(authFlowCoordinator)
        authFlowCoordinator.start()
    }

	private func showMainFlow() {
        let mainFlowCoordinator = factory.makeMainCoordinator(
            delegate: self,
            navigationController: navigationController
        )
        addChildCoordinator(mainFlowCoordinator)
        mainFlowCoordinator.start()
    }

	private func showPinCodeFlow() {
        let pinCodeFlowCoordinator = factory.makePinCoordinator(
            delegate: self,
            navigationController: navigationController
        )
        addChildCoordinator(pinCodeFlowCoordinator)
        pinCodeFlowCoordinator.start()
    }
    
    func updateAppState() {
        guard keychainService.isPinCodeEnabled == true
        else {
            return
        }
        
        let diffTimeInterval = timeService.diffSinceLastBackgroundEnter()
        
        // Если приложение 30 минут в бэкграунде, то перезапрашиваем пин
        userSettings.isLocalAuth = diffTimeInterval.minutes >= 30
    }
}

// MARK: - Coordinator

extension AppCoordinator: Coordinator {
	func start() {
        
        if userSettings[.isAppNotFirstStart] == false {
            privateDataCleaner.resetPrivateData()
            keychainService.isPinCodeEnabled = true
        }
        userSettings[.isAppNotFirstStart] = true
        userSettings.isLocalAuth = keychainService.isPinCodeEnabled == true

		let flow = AppLaunchInstructor.configure(
			isAuthorized: userSettings.isAuthFlowFinished,
			isLocalAuth: userSettings.isLocalAuth
		)

		switch flow {
		case .localAuth:
			if userSettings.isLocalAuth {
				showPinCodeFlow()
			} else {
				NotificationCenter.default.post(name: .userDidLoggedIn, object: nil)
				showMainFlow()
			}
		case .authentication:
			showAuthenticationFlow()
		case .main:
			NotificationCenter.default.post(name: .userDidLoggedIn, object: nil)
			showMainFlow()
		}
	}
}

// MARK: - AppCoordinatorProtocol

extension AppCoordinator: AppCoordinatorProtocol {

	func didReceive(notification: UNNotificationResponse, completion: @escaping () -> Void) {

        let pushCoordinator = factory.makePushCoordinator(
            notification: notification,
            delegate: self,
            navigationController: navigationController
        ) { [weak self] in
            guard
                let chatRoomDelegate = self?.childCoordinators
                    .values.first(where: { $0 is ChatRoomSceneDelegate }) as? ChatRoomSceneDelegate
            else {
                return nil
            }
            return chatRoomDelegate
        }

		if !userSettings.isLocalAuth && userSettings.isAuthFlowFinished {
			addChildCoordinator(pushCoordinator)
			pushCoordinator.start()
		} else {
			pendingCoordinators.append(pushCoordinator)
		}
		completion()
	}
}

// MARK: - AppCoordinator (AuthFlowCoordinatorDelegate)

extension AppCoordinator: AuthFlowCoordinatorDelegate {
    func userPerformedAuthentication(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        if userSettings.isLocalAuth {
			NotificationCenter.default.post(name: .userDidRegistered, object: nil)
            showMainFlow()
        } else {
            showPinCodeFlow()
        }
    }
}

// MARK: - MainFlowCoordinatorDelegate

extension AppCoordinator: MainFlowCoordinatorDelegate {
    func userPerformedLogout(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showAuthenticationFlow()
    }

	func didEndStartProcess(coordinator: Coordinator) {
		guard !pendingCoordinators.isEmpty,
		let pendingCoordinator = pendingCoordinators.last else { return }
		pendingCoordinators.removeLast()
		addChildCoordinator(pendingCoordinator)
		pendingCoordinator.start()
	}
}

// MARK: - PinCodeFlowCoordinatorDelegate

extension AppCoordinator: PinCodeFlowCoordinatorDelegate {
    func userApprovedAuthentication(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        if userSettings.isAuthFlowFinished {
			NotificationCenter.default.post(name: .userDidLoggedIn, object: nil)
            showMainFlow()
        } else {
            showAuthenticationFlow()
        }
    }
}

// MARK: - PushNotificationCoordinatorDelegate

extension AppCoordinator: PushNotificationCoordinatorDelegate {
	func didFinishFlow(coordinator: Coordinator) {
		removeChildCoordinator(coordinator)
	}
}