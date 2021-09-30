import Foundation

// MARK: - ProfileDetailSceneDelegate

protocol ProfileDetailSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - ProfileDetailViewInterface

protocol ProfileDetailViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - ProfileDetailPresentation

protocol ProfileDetailPresentation: AnyObject {
    func handleButtonTap()
}
