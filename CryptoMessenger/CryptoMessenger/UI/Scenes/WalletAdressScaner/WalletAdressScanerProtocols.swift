import Foundation

// MARK: - WalletAddressScanerSceneDelegate

protocol WalletAddressScanerSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
