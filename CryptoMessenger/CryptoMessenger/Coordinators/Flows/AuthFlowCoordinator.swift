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
    @Injectable private var userFlows: UserFlowsStorageService

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Internal Methods

    func start() {
        // handleNextScene(.test)
        handleNextScene(userFlows.isOnboardingFlowFinished ? .registration : .onboarding)
    }

    // MARK: - Private Methods

    private func showOnboardingScene() {
        let viewController = OnboardingConfigurator.configuredViewController(delegate: self)
        setViewWith(viewController)
    }

    private func showRegistrationScene() {
        let viewController = RegistrationConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showVerificationScene() {
        let viewController = VerificationConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showGenerationInfoScene() {
        let viewController = GenerationInfoConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showKeyImportScene() {
        let viewController = KeyImportConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showCountryCodeScene(_ countryCodeDelegate: CountryCodePickerDelegate) {
        let viewController = CountryCodePickerViewController()
        viewController.delegate = countryCodeDelegate
        let nvc = BaseNavigationController(rootViewController: viewController)
        navigationController.viewControllers.last?.present(nvc, animated: true)
    }

    private func showCallListScene() {
        let viewController = CallListConfigurator.configuredViewController(delegate: self)
        setViewWith(viewController)
    }

    private func showPinCodeScene() {
        let viewController = PinCodeConfigurator.configuredViewController(delegate: self)
        setViewWith(viewController)
    }

    private func showPhotoEditorScene(images: [UIImage]) {
        let viewController = PhotoEditorConfigurator.configuredViewController(images: images, delegate: self)
        setViewWith(viewController)
    }

    private func showProfileNetworkDetailScene() {
        let viewController = ProfileNetworkDetailConfigurator.configuredViewController(delegate: self)
        setViewWith(viewController)
    }

    private func showAboutAppScene() {
        let viewController = AboutAppConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showBlockedUserScene() {
        let viewController = BaseHostingController(rootView: BlockedUserContentView())
        setViewWith(viewController)
    }

    private func showSession() {
        let viewController = BaseHostingController(rootView: SessionListView())
        setViewWith(viewController)
    }

    private func showSecurityScene() {
        let viewController = SecurityConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
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
        case generationInfo
        case keyImport
        case main
        case callList
        case countryCode(CountryCodePickerDelegate)
        case pinCode
        case photoEditor
        case profileNetwork
        case aboutApp
        case blockedUser
        case userSession
        case security
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
        case .generationInfo:
            showGenerationInfoScene()
        case .countryCode(let delegate):
            showCountryCodeScene(delegate)
        case .keyImport:
            showKeyImportScene()
        case .pinCode:
            showPinCodeScene()
        case .callList:
            showCallListScene()
        case .photoEditor:
            showPhotoEditorScene(images: [])
        case .profileNetwork:
            showProfileNetworkDetailScene()
        case .aboutApp:
            showAboutAppScene()
        case .userSession:
            showSession()
        case .security:
            showSecurityScene()
        case .blockedUser:
            showBlockedUserScene()
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

// MARK: - AuthFlowCoordinator (GenerationInfoSceneDelegate)

extension AuthFlowCoordinator: GenerationInfoSceneDelegate {}

// MARK: - AuthFlowCoordinator (OnboardingSceneDelegate)

extension AuthFlowCoordinator: OnboardingSceneDelegate {}

// MARK: - AuthFlowCoordinator (KeyImportSceneDelegate)

extension AuthFlowCoordinator: KeyImportSceneDelegate {}

// MARK: - AuthFlowCoordinator (CallListSceneDelegate)

extension AuthFlowCoordinator: CallListSceneDelegate {}

// MARK: - AuthFlowCoordinator (PhotoEditorSceneDelegate)

extension AuthFlowCoordinator: PhotoEditorSceneDelegate {}

// MARK: - AuthFlowCoordinator (PinCodeSceneDelegate)

extension AuthFlowCoordinator: PinCodeSceneDelegate {
    func handleNextScene() {
        if userFlows.isAuthFlowFinished {
            handleNextScene(.main)
        } else {
            restartFlow()
        }
    }
}

// MARK: - AuthFlowCoordinator (ProfileNetworkDetailSceneDelegate)

extension AuthFlowCoordinator: ProfileNetworkDetailSceneDelegate {}

// MARK: - AuthFlowCoordinator (AboutAppSceneDelegate)

extension AuthFlowCoordinator: AboutAppSceneDelegate {}

// MARK: - AuthFlowCoordinator (SecuritySceneDelegate)

extension AuthFlowCoordinator: SecuritySceneDelegate {}
