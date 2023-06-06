import Foundation

// MARK: - OnboardingSceneDelegate

protocol OnboardingSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}
