import UIKit

protocol AppCoordinatorProtocol {
	func didReceive(notification: UNNotificationResponse, completion: @escaping () -> Void)
}

final class AppCoordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]

	private var pendingCoordinators = [Coordinator]()

    private(set) var navigationController: UINavigationController

    // MARK: - Private Properties

    private let userFlows: UserFlowsStorage

	private let dependenciesService: DependenciesServiceProtocol
	private let firebaseService: FirebaseServiceProtocol
	private let keychainService: KeychainServiceProtocol
	@Injectable var matrixStore: MatrixStore

    // MARK: - Lifecycle

    init(
		dependenciesService: DependenciesServiceProtocol,
		firebaseService: FirebaseServiceProtocol,
		keychainService: KeychainServiceProtocol,
		userFlows: UserFlowsStorage,
		navigationController: UINavigationController
	) {
		self.dependenciesService = dependenciesService
		self.firebaseService = firebaseService
		self.keychainService = keychainService
		self.userFlows = userFlows
        self.navigationController = navigationController
    }

    // MARK: - Private Methods

	private func startServices() {
		dependenciesService.configureDependencies()
		firebaseService.configure()
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
        let mainFlowCoordinator = MainFlowCoordinator(navigationController: navigationController)
        mainFlowCoordinator.delegate = self
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

		startServices()

		let flow = AppLaunchInstructor.configure(
			isAuthorized: userFlows.isAuthFlowFinished,
			isLocalAuth: userFlows.isLocalAuth
		)

		switch flow {
		case .localAuth:
			if userFlows.isLocalAuth {
				showPinCodeFlow()
			} else {
				showMainFlow()
			}
		case .authentication:
			showAuthenticationFlow()
		case .main:
			showMainFlow()
		}
	}
}

// MARK: - AppCoordinatorProtocol

extension AppCoordinator: AppCoordinatorProtocol {

	func didReceive(notification: UNNotificationResponse, completion: @escaping () -> Void) {
		// TODO: Add handler
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

// MARK: - AppCoordinator (MainFlowCoordinatorDelegate)

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

// MARK: - AppCoordinator (PinCodeFlowCoordinatorDelegate)

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
