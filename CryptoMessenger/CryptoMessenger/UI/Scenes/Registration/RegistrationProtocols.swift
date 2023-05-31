import Foundation

// MARK: - RegistrationSceneDelegate

protocol RegistrationSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}
