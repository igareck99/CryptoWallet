import Foundation

// MARK: - SessionSceneDelegate

protocol SessionSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
    func restartFlow()
}
