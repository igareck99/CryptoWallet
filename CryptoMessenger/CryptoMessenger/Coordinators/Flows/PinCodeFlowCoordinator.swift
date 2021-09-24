import UIKit

// MARK: - PinCodeFlowCoordinatorDelegate

protocol PinCodeFlowCoordinatorDelegate: AnyObject {
    func userApprovedAuthentication(coordinator: Coordinator)
}

// MARK: - PinCodeFlowCoordinatorSceneDelegate

protocol PinCodeFlowCoordinatorSceneDelegate: AnyObject {
    func handleNextScene(_ scene: PinCodeFlowCoordinator.Scene)
    func switchFlow()
}

// MARK: - PinCodeFlowCoordinator

public final class PinCodeFlowCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]
    weak var delegate: PinCodeFlowCoordinatorDelegate?
    let navigationController: UINavigationController
    @Injectable private var userFlows: UserFlowsStorageService

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Internal Methods

    func start() {
        handleNextScene(.pinCode)
    }

    // MARK: - Private Methods

    private func showPinCodeScene() {
        let viewController = PinCodeConfigurator.configuredViewController(delegate: self)
        setViewWith(viewController)
    }

    // MARK: - Scene

    enum Scene {
        case pinCode
    }
}

// MARK: - PinCodeFlowCoordinator (PinCodeFlowCoordinatorSceneDelegate)

extension PinCodeFlowCoordinator: PinCodeFlowCoordinatorSceneDelegate {
    func handleNextScene(_ scene: PinCodeFlowCoordinator.Scene) {
        switch scene {
        case .pinCode:
            showPinCodeScene()
        }
    }

    func switchFlow() {
        delegate?.userApprovedAuthentication(coordinator: self)
    }
}

// MARK: - PinCodeFlowCoordinator (PinCodeAuthSceneDelegate)

extension PinCodeFlowCoordinator: PinCodeAuthSceneDelegate {}
