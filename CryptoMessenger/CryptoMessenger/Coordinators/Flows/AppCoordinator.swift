import UIKit

// MARK: - AppCoordinator

final class AppCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]

    private(set) var navigationController: UINavigationController

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Internal Methods

    func start() {
        let flow: AppFlow = .authentication
        switch flow {
        case .authentication:
            showAuthenticationFlow()
        }
    }

    func showAuthenticationFlow() {
        let authFlowCoordinator = AuthFlowCoordinator(navigationController: navigationController)
        authFlowCoordinator.delegate = self
        addChildCoordinator(authFlowCoordinator)
        authFlowCoordinator.start()
    }

    enum AppFlow {
        case authentication
    }
}

// MARK: - AppCoordinator (AuthFlowCoordinatorDelegate)

extension AppCoordinator: AuthFlowCoordinatorDelegate {
    func userPerformedAuthentication(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
}
