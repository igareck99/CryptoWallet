import SwiftUI
import UIKit

// MARK: - AuthFlowCoordinatorDelegate

protocol AuthFlowCoordinatorDelegate: AnyObject {
    func userPerformedAuthentication(coordinator: Coordinator)
}

// MARK: - AuthFlowCoordinatorSceneDelegate

protocol AuthFlowCoordinatorSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
    func switchFlow()
}

// MARK: - AuthFlowCoordinator

public final class AuthFlowCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]
    weak var delegate: AuthFlowCoordinatorDelegate?
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
        // handleNextScene(.test)
        handleNextScene(userFlows.isOnboardingFlowFinished ? .registration : .onboarding)
    }

    // MARK: - Private Methods

    private func showOnboardingScene() {
        let view = OnboardingAssembly.build(delegate: self)
        let viewController = BaseHostingController(rootView: view)
        setViewWith(viewController)
    }

    private func showRegistrationScene() {
        let view = RegistrationConfigurator.build(delegate: self)
        let viewController = BaseHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showVerificationScene() {
        let view = VerificationConfigurator.build(delegate: self)
        let viewController = BaseHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showCountryCodeScene(_ countryCodeDelegate: CountryCodePickerDelegate) {
        let viewController = CountryCodePickerViewController()
        viewController.delegate = countryCodeDelegate
        let nvc = BaseNavigationController(rootViewController: viewController)
        navigationController.viewControllers.last?.present(nvc, animated: true)
    }

    private func showProfile() {
        // let viewController = BaseHostingController(rootView: ProfileView(viewModel: .init()))
        let viewController = BaseHostingController(rootView: SocialListView())
        setViewWith(viewController)
    }

    // MARK: - Scene

    enum Scene {

        // MARK: - Types

        case onboarding
        case registration
        case verification
        case main
        case countryCode(CountryCodePickerDelegate)
    }
}

// MARK: - AuthFlowCoordinator (AuthFlowCoordinatorSceneDelegate)

extension AuthFlowCoordinator: AuthFlowCoordinatorSceneDelegate {
    func handleNextScene(_ scene: Scene) {
        switch scene {
        case .main:
            switchFlow()
        case .onboarding:
            showOnboardingScene()
        case .registration:
            showRegistrationScene()
        case .verification:
            showVerificationScene()
        case .countryCode(let delegate):
            showCountryCodeScene(delegate)
        }
    }

    func restartFlow() {
        start()
    }

    func switchFlow() {
        delegate?.userPerformedAuthentication(coordinator: self)
    }
}

// MARK: - AuthFlowCoordinator (RegistrationSceneDelegate)

extension AuthFlowCoordinator: RegistrationSceneDelegate {}

// MARK: - AuthFlowCoordinator (VerificationSceneDelegate)

extension AuthFlowCoordinator: VerificationSceneDelegate {}

// MARK: - AuthFlowCoordinator (OnboardingSceneDelegate)

extension AuthFlowCoordinator: OnboardingSceneDelegate {}
