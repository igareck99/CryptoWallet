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

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Internal Methods

    func start() {
        handleNextScene(.generationInfo)
    }

    func showOnboardingScene() {
        let viewController = OnboardingConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showRegistrationScene() {
        let viewController = RegistrationConfigurator.configuredViewController(delegate: self)
        setViewWith(viewController)
    }

    func showVerificationScene() {
        let viewController = VerificationConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showGenerationInfoScene() {
        let viewController = GenerationInfoConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showKeyImportScene() {
        let viewController = KeyImportConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCountryCodeScene(_ countryCodeDelegate: CountryCodePickerDelegate) {
        let viewController = CountryCodePickerViewController()
        viewController.delegate = countryCodeDelegate
        let nvc = BaseNavigationController(rootViewController: viewController)
        navigationController.viewControllers.last?.present(nvc, animated: true)
    }

    enum Scene {
        case registration
        case verification
        case generationInfo
        case onboarding
        case keyImport
        case countryCode(CountryCodePickerDelegate)
    }
}

// MARK: - AuthFlowCoordinatorSceneDelegate

extension AuthFlowCoordinator: AuthFlowCoordinatorSceneDelegate {
    func handleNextScene(_ scene: Scene) {
        switch scene {
        case .registration:
            showRegistrationScene()
        case .verification:
            showVerificationScene()
        case .generationInfo:
            showGenerationInfoScene()
        case .onboarding:
            showOnboardingScene()
        case .countryCode(let delegate):
            showCountryCodeScene(delegate)
        case .keyImport:
            showKeyImportScene()
        }
    }

    func switchFlow() {}
}

// MARK: - AuthFlowCoordinator (RegistrationSceneDelegate)

extension AuthFlowCoordinator: RegistrationSceneDelegate {}

// MARK: - AuthFlowCoordinator (VerificationSceneDelegate)

extension AuthFlowCoordinator: VerificationSceneDelegate {}

// MARK: - AuthFlowCoordinator (GenerationInfoSceneDelegate)

extension AuthFlowCoordinator: GenerationInfoSceneDelegate {}

// MARK: - AuthFlowCoordinator (OnboardingSceneDelegate)

extension AuthFlowCoordinator: OnboardingSceneDelegate {}

// MARK: - AuthFlowCoordinator (KeyImportSceneDelegate)

extension AuthFlowCoordinator: KeyImportSceneDelegate {}
