import UIKit

protocol AppCoordinatorProtocol {
	func didReceive(notification: UNNotificationResponse, completion: @escaping () -> Void)
}

final class AppCoordinator {

    var childCoordinators: [String: Coordinator] = [:]
	private(set) var navigationController: UINavigationController

	private var pendingCoordinators = [Coordinator]()
    private let userFlows: UserFlowsStorage
	private let keychainService: KeychainServiceProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage = UserDefaultsService.shared

    init(
		keychainService: KeychainServiceProtocol,
		userFlows: UserFlowsStorage,
		navigationController: UINavigationController
	) {
		self.keychainService = keychainService
		self.userFlows = userFlows
        self.navigationController = navigationController
    }

	private func showAuthenticationFlow() {
		let userFlows = UserDefaultsService.shared
        let authFlowCoordinator = AuthFlowCoordinator(
			userFlows: userFlows,
			navigationController: navigationController
		)
        authFlowCoordinator.delegate = self
        addChildCoordinator(authFlowCoordinator)
        authFlowCoordinator.start()
    }

	private func showMainFlow() {

		let mainFlowCoordinator = MainFlowCoordinatorAssembly.build(
			delegate: self,
			navigationController: navigationController
		)
        addChildCoordinator(mainFlowCoordinator)
        mainFlowCoordinator.start()
    }

	private func showPinCodeFlow() {
		let userFlows = UserDefaultsService.shared
        let pinCodeFlowCoordinator = PinCodeFlowCoordinator(
			userFlows: userFlows,
			navigationController: navigationController
		)
        pinCodeFlowCoordinator.delegate = self
        addChildCoordinator(pinCodeFlowCoordinator)
        pinCodeFlowCoordinator.start()
    }
}

// MARK: - Coordinator

extension AppCoordinator: Coordinator {
	func start() {

		let flow = AppLaunchInstructor.configure(
			isAuthorized: userFlows.isAuthFlowFinished,
			isLocalAuth: userFlows.isLocalAuth
		)

		debugPrint("flow.description: \(flow.description)")

		switch flow {
		case .localAuth:
			if userFlows.isLocalAuth {
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
        
		let getChatRoomSceneDelegate: () -> ChatRoomSceneDelegate? = { [weak self] in
			guard
				let chatRoomDelegate = self?.childCoordinators
					.values.first(where: { $0 is ChatRoomSceneDelegate }) as? ChatRoomSceneDelegate
			else {
				return nil
			}
			return chatRoomDelegate
		}
        
        let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
        let togglesFacade = MainFlowTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)

		let pushCoordinator = PushNotificationCoordinatorAssembly.build(
			getChatRoomSceneDelegate: getChatRoomSceneDelegate,
			notificationResponse: notification,
			navigationController: self.navigationController,
            delegate: self,
            toggleFacade: togglesFacade
		)

		if !userFlows.isLocalAuth && userFlows.isAuthFlowFinished {
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
        if userFlows.isLocalAuth {
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
        if userFlows.isAuthFlowFinished {
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
