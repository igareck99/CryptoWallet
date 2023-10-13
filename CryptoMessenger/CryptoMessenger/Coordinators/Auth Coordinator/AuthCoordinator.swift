import SwiftUI
import UIKit

// MARK: - AuthCoordinatorDelegate

protocol AuthCoordinatorDelegate: AnyObject {
    func userPerformedAuthentication(coordinator: Coordinator)
}

// MARK: - AuthFlowCoordinator

final class AuthCoordinator<Router: AuhtRouterable>: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]
    weak var delegate: AuthCoordinatorDelegate?
    private let userFlows: UserFlowsStorage
    let router: Router
    var renderView: (any View) -> Void

    // MARK: - Lifecycle

    init(
        router: Router,
        userFlows: UserFlowsStorage,
        renderView: @escaping (any View) -> Void
    ) {
        self.router = router
		self.userFlows = userFlows
        self.renderView = renderView
    }

    // MARK: - Internal Methods

    func start() {
        renderView(router)
    }
}

// MARK: - OnboardingSceneDelegate

extension AuthCoordinator: OnboardingSceneDelegate {
    func onFinishOnboarding() {
        router.showRegistrationScene(delegate: self)
    }
    
    
}

// MARK: - RegistrationSceneDelegate

extension AuthCoordinator: RegistrationSceneDelegate {
    func onFinishInputPhone() {
        router.showVerificationScene(delegate: self)
    }

    func onTapCountryCodeSelect(delegate: CountryCodePickerDelegate) {
        router.showCountryCodeScene(delegate: delegate)
    }
}

// MARK: - VerificationSceneDelegate

extension AuthCoordinator: VerificationSceneDelegate {
    func onVerificationSuccess() {
        delegate?.userPerformedAuthentication(coordinator: self)
        router.resetState()
    }
}
