import Foundation

// MARK: - OnboardingSceneDelegate

protocol OnboardingSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - OnboardingViewInterface

protocol OnboardingViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - OnboardingPresentation

protocol OnboardingPresentation: AnyObject {
    typealias OnboardingPage = OnboardingPresenter.OnboardingPage

    var pages: [OnboardingPage] { get }

    func handleContinueButtonTap()
}
