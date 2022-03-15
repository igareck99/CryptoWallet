import Foundation

// MARK: - TransferSceneDelegate

protocol TransferSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
