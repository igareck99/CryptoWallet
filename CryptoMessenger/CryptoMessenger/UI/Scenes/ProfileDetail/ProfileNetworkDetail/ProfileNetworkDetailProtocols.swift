import Foundation

// MARK: - ProfileNetworkDetailSceneDelegate

protocol ProfileNetworkDetailSceneDelegate: AnyObject {
    func handleButtonTap(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - ProfileNetworkDetailViewInterface

protocol ProfileNetworkDetailViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - ProfileNetworkDetailPresentation

protocol ProfileNetworkDetailPresentation: AnyObject {
    func handleButtonTap()
}
