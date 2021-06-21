import UIKit

// MARK: AppCoordinator

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
        let flow: AppFlow = .camera
        switch flow {
        case .authentication:
            showAuthenticationFlow()
        case .camera:
            showCameraFlow()
        }
    }

    func showStartScene() {
        navigationController.pushViewController(
            StartConfigurator.configuredViewController(delegate: self), animated: false
        )
    }

    func showAuthenticationFlow() {
        let authFlowCoordinator = AuthFlowCoordinator(navigationController: navigationController)
        authFlowCoordinator.delegate = self
        addChildCoordinator(authFlowCoordinator)
        authFlowCoordinator.start()
    }

    func showCameraFlow() {
        let cameraFlowCoordinator = CameraFlowCoordinator(navigationController: navigationController)
        cameraFlowCoordinator.delegate = self
        addChildCoordinator(cameraFlowCoordinator)
        cameraFlowCoordinator.start()
    }

    enum AppFlow {
        case authentication
        case camera
    }
}

// MARK: - AppCoordinator (StartPresenterDelegate)

extension AppCoordinator: StartPresenterDelegate {
    func userNeedsToAuthenticate() {
        showAuthenticationFlow()
    }

    func userIsAuthenticated() {
        showAuthenticationFlow()
    }
}

// MARK: - AppCoordinator (AuthFlowCoordinatorDelegate)

extension AppCoordinator: AuthFlowCoordinatorDelegate {
    func userPerformedAuthentication(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showCameraFlow()
    }
}

// MARK: - AppCoordinator (NewFlowCoordinatorDelegate)

extension AppCoordinator: CameraFlowCoordinatorDelegate {
    func userPerformedCamera(coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showAuthenticationFlow()
    }
}
