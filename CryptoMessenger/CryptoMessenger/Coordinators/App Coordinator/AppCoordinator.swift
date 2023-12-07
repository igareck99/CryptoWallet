import Combine
import SwiftUI
import UIKit

// swiftlint:disable all

typealias RootViewBuilder = (any View) -> Void

protocol AppCoordinatorProtocol {
	func didReceive(notification: UNNotificationResponse, completion: @escaping () -> Void)
}

protocol RootCoordinatable: ObservableObject {
    var controller: UIViewController { get }
}

final class AppCoordinator: RootCoordinatable {
    @Published var rootView: AnyView = Text("").anyView()
    
    var controller: UIViewController {
        hostController
    }
    
    lazy var hostController: UIHostingController = {
        UIHostingController(rootView: rootView)
    }()
    
    var childCoordinators: [String: Coordinator] = [:]
    var statusBarUseCase = StatusBarCallUseCase.shared

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
        timeService: AppTimeServiceProtocol
	) {
		self.keychainService = keychainService
		self.userSettings = userSettings
        self.router = router
        self.factory = factory
        self.privateDataCleaner = privateDataCleaner
        self.timeService = timeService
    }

	private func showAuthenticationFlow() {
        let authFlowCoordinator = factory.makeAuthCoordinator(
            delegate: self,
            isOnboardingFinish: userSettings.isOnboardingFlowFinished,
            renderView: { [weak self] view in
                guard let self = self else { return }
                self.rootView = view.anyView()
                hostController.rootView = self.rootView
            }
        )
        addChildCoordinator(authFlowCoordinator)
        authFlowCoordinator.start()
    }

	private func showMainFlow() {
        var mainFlowCoordinator: Coordinator?
        let onlogout: () -> Void = { [weak self] in
            if let coordinator = mainFlowCoordinator {
                self?.removeChildCoordinator(coordinator)
            }
            self?.logoutLogic()
        }
        mainFlowCoordinator = factory.makeMainCoordinator(
            delegate: self,
            renderView: { [weak self] view in
                guard let self = self else { return }
                self.rootView = view.anyView()
                hostController.rootView = self.rootView
            },
            onlogout: onlogout
        )
        guard let coordinator = mainFlowCoordinator else { return }
        addChildCoordinator(coordinator)
        coordinator.start()
    }

	private func showPinCodeFlow() {
        let pinCodeFlowCoordinator = factory.makePinCoordinator(
            delegate: self,
            renderView: { [weak self] view in
                guard let self = self else { return }
                self.rootView = view.anyView()
                hostController.rootView = self.rootView
            }, onLogin: {
                self.showMainFlow()
            }
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
    
    func logoutLogic() {
        start()
    }
}

// MARK: - Coordinator

extension AppCoordinator: Coordinator {

	func start() {
        
        if userSettings[.isAppNotFirstStart] == false {
            privateDataCleaner.resetPrivateData()
            keychainService.isPinCodeEnabled = false
        }

        userSettings[.isAppNotFirstStart] = true
        userSettings.isLocalAuth = keychainService.isPinCodeEnabled == true
        let userId = UserDefaultsService.shared.userId
        let accServiceName = keychainService.getAccServiceName()
        let accServiceNameId = keychainService.getAccServiceNameId()
        
        debugPrint("keychainService: UD userId \(userId)")
        debugPrint("keychainService: KC accServiceName \(accServiceName)")
        debugPrint("keychainService: KC accServiceNameId \(accServiceNameId)")
        debugPrint("keychainService")

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
            delegate: self
        )

		if !userSettings.isLocalAuth && userSettings.isAuthFlowFinished {
			addChildCoordinator(pushCoordinator)
			pushCoordinator.start()
		} else {
			pendingCoordinators.append(pushCoordinator)
		}
		completion()
	}
}

// MARK: - AuthFlowCoordinatorDelegate

extension AppCoordinator: AuthCoordinatorDelegate {
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
