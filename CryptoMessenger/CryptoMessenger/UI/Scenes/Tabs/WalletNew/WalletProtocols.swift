import Foundation

// MARK: - WalletSceneDelegate

protocol WalletSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
