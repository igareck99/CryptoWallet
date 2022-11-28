import Foundation

// MARK: - SecuritySceneDelegate

protocol SecuritySceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
