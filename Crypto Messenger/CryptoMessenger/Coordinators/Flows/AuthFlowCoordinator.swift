import UIKit

// MARK: AuthFlowCoordinatorDelegate

protocol AuthFlowCoordinatorDelegate: AnyObject {
    func userPerformedAuthentication(coordinator: Coordinator)
}

// MARK: AuthFlowCoordinatorSceneDelegate

protocol AuthFlowCoordinatorSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
    func switchFlow()
}

// MARK: AuthFlowCoordinator

public final class AuthFlowCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]
    weak var delegate: AuthFlowCoordinatorDelegate?

    let navigationController: UINavigationController

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Internal Methods

    func start() {
        handleNextScene(.onboarding)
    }

    func showOnboardingScene() {
        let viewController = UIViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

    func showNextScene() {
        let viewController = UIViewController()
        setViewWith(viewController)
    }

    enum Scene {
        case onboarding
        case nextScene
    }
}

// MARK: - AuthFlowCoordinatorSceneDelegate

extension AuthFlowCoordinator: AuthFlowCoordinatorSceneDelegate {
    func handleNextScene(_ scene: Scene) {
        switch scene {
        case .onboarding:
            showOnboardingScene()
        case .nextScene:
            showNextScene()
        }
    }

    func switchFlow() {}
}

// MARK: - AuthFlowCoordinator (OnboardingSceneDelegate)

extension AuthFlowCoordinator: OnboardingSceneDelegate {}

// MARK: - AuthFlowCoordinator (NextSceneDelegate)

extension AuthFlowCoordinator: NextSceneDelegate {}


