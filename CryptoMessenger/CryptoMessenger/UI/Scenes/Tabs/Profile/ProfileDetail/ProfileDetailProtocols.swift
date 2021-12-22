import Foundation

// MARK: - ProfileDetailSceneDelegate

protocol ProfileDetailSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
    func restartFlow()
}
