import UIKit

// MARK: - PinCodeFlowCoordinatorDelegate

protocol PinCodeFlowCoordinatorDelegate: AnyObject {
    func userApprovedAuthentication(coordinator: Coordinator)
}

// MARK: - PinCodeFlowCoordinatorSceneDelegate

protocol PinCodeFlowCoordinatorSceneDelegate: AnyObject {
    func switchFlow()
}

// MARK: - PinCodeFlowCoordinator

public final class PinCodeFlowCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]
    weak var delegate: PinCodeFlowCoordinatorDelegate?
    let navigationController: UINavigationController
    private let userFlows: UserFlowsStorage

    // MARK: - Lifecycle

    init(
		userFlows: UserFlowsStorage,
		navigationController: UINavigationController
	) {
		self.userFlows = userFlows
        self.navigationController = navigationController
    }

    // MARK: - Internal Methods

    func start() {
        showPinCodeScene()
    }

    // MARK: - Private Methods

    private func showPinCodeScene() {
        let viewController = PinCodeConfigurator.configuredViewController(delegate: self)
        setViewWith(viewController)
    }
}

// MARK: - PinCodeFlowCoordinator (PinCodeFlowCoordinatorSceneDelegate)

extension PinCodeFlowCoordinator: PinCodeFlowCoordinatorSceneDelegate {
    func switchFlow() {
        delegate?.userApprovedAuthentication(coordinator: self)
    }
}

// MARK: - PinCodeFlowCoordinator (PinCodeSceneDelegate)

extension PinCodeFlowCoordinator: PinCodeSceneDelegate {
    func handleNextScene() {
        switchFlow()
    }
}
