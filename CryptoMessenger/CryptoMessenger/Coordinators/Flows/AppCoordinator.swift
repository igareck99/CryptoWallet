import UIKit

// MARK: - AppCoordinator

final class AppCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]

    private(set) var navigationController: UINavigationController

    // MARK: - Private Properties

    @Injectable private var userFlows: UserFlowsStorageService

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Internal Methods

    func start() {
        userFlows.isOnboardingFlowFinished = true
        userFlows.isAuthFlowFinished = true
        userFlows.isLocalAuth = true
        let flow = AppLaunchInstructor.configure(
            isOnboardingShown: userFlows.isOnboardingFlowFinished,
            isAuthorized: userFlows.isAuthFlowFinished,
            isLocalAuth: userFlows.isLocalAuth
        )
        print("userFlows.isOnboardingFlowFinished   \(userFlows.isOnboardingFlowFinished)")
        print("userFlows.isAuthFlowFinished   \(userFlows.isAuthFlowFinished)")
        print("userFlows.isLocalAuth   \(userFlows.isLocalAuth)")
        print(flow)
        switch flow {
        case .authentication, .onboarding:
            showAuthenticationFlow()
        case .main:
            showMainFlow()
        case .localauth:
            showPinCodeFlow()
        }
    }

    func showAuthenticationFlow() {
        let authFlowCoordinator = AuthFlowCoordinator(navigationController: navigationController)
        authFlowCoordinator.delegate = self
        addChildCoordinator(authFlowCoordinator)
        authFlowCoordinator.start()
    }

    func showMainFlow() {
        let mainFlowCoordinator = MainFlowCoordinator(navigationController: navigationController)
        mainFlowCoordinator.delegate = self
        addChildCoordinator(mainFlowCoordinator)
        mainFlowCoordinator.start()
    }

    func showPinCodeFlow() {
        let pinCodeFlowCoordinator = PinCodeFlowCoordinator(navigationController: navigationController)
        pinCodeFlowCoordinator.delegate = self
        addChildCoordinator(pinCodeFlowCoordinator)
        pinCodeFlowCoordinator.start()
    }
}

// MARK: - AppCoordinator (AuthFlowCoordinatorDelegate)

extension AppCoordinator: AuthFlowCoordinatorDelegate {
    func userPerformedAuthentication(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showMainFlow()
    }
}

// MARK: - AppCoordinator (MainFlowCoordinatorDelegate)

extension AppCoordinator: MainFlowCoordinatorDelegate {
    func userPerformedLogout(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showAuthenticationFlow()
    }
}

// MARK: - AppCoordinator (PinCodeFlowCoordinatorDelegate)

extension AppCoordinator: PinCodeFlowCoordinatorDelegate {
    func userApprovedAuthentication(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showPinCodeFlow()
    }
}
