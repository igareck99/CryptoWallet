import Foundation

// MARK: - VerificationSceneDelegate

protocol VerificationSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}
