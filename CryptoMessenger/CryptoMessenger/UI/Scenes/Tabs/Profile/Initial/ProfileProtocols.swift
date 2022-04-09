import Foundation

// MARK: - ProfileSceneDelegate

protocol ProfileSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
    func restartFlow()
}
