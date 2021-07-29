import Foundation

// MARK: - WalletSceneDelegate

protocol WalletSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - WalletViewInterface

protocol WalletViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - WalletPresentation

protocol WalletPresentation: AnyObject {
    func handleButtonTap()
}
