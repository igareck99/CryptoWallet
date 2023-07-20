import SwiftUI
import UIKit

// MARK: - AuthCoordinatorDelegate

protocol AuthCoordinatorDelegate: AnyObject {
    func userPerformedAuthentication(coordinator: Coordinator)
}

// MARK: - AuthCoordinatorSceneDelegate

protocol AuthCoordinatorSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthCoordinator.Scene)
    func switchFlow()
}

// MARK: - AuthFlowCoordinator

public final class AuthCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]
    weak var delegate: AuthCoordinatorDelegate?
    var navigationController: UINavigationController
    private let userFlows: UserFlowsStorage
    let router: AuhtRouterable
    let renderView: (Coordinator) -> Void

    // MARK: - Lifecycle

    init(
        router: AuhtRouterable,
        userFlows: UserFlowsStorage,
        navigationController: UINavigationController,
        renderView: @escaping (Coordinator) -> Void
    ) {
        self.router = router
		self.userFlows = userFlows
        self.navigationController = navigationController
        self.renderView = renderView
    }

    // MARK: - Internal Methods

    func start() {
        handleNextScene(userFlows.isOnboardingFlowFinished ? .registration : .onboarding)
        renderView(self)
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

// MARK: - AuthCoordinatorSceneDelegate

extension AuthCoordinator: AuthCoordinatorSceneDelegate {
    func handleNextScene(_ scene: Scene) {
        switch scene {
        case .main:
                switchFlow()
        case .onboarding:
                router.makeOnboardingViewRoot(delegate: self)
        case .registration:
                router.showRegistrationScene(delegate: self)
        case .verification:
                router.showVerificationScene(delegate: self)
        case .countryCode(let delegate):
                router.showCountryCodeScene(delegate)
        }
    }

    func restartFlow() {
        start()
    }

    func switchFlow() {
        delegate?.userPerformedAuthentication(coordinator: self)
    }
}

// MARK: - OnboardingSceneDelegate

extension AuthCoordinator: OnboardingSceneDelegate {
    func onFinishOnboarding() {
        handleNextScene(.registration)
    }
}

// MARK: - RegistrationSceneDelegate

extension AuthCoordinator: RegistrationSceneDelegate {
    func onFinishInputPhone() {
        router.showVerificationScene(delegate: self)
    }

    func onTapCountryCodeSelect(delegate: CountryCodePickerDelegate) {
        router.showCountryCodeScene(delegate)
    }
}

// MARK: - VerificationSceneDelegate

extension AuthCoordinator: VerificationSceneDelegate {
    func onVerificationSuccess() {
        switchFlow()
    }
}
