import Foundation

// MARK: - CallListSceneDelegate

protocol CallListSceneDelegate: AnyObject {
    func handleButtonTap(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - CallListViewInterface

protocol CallListViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - CallListPresentation

protocol CallListPresentation: AnyObject {
    func handleButtonTap()
}
