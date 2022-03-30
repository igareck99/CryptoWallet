import Foundation

// MARK: - WalletManagerSceneDelegate

protocol WalletManagerSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
