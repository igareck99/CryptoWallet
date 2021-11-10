import Foundation

// MARK: - SessionDetailSceneDelegate

protocol SessionDetailSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - SessionDetailViewInterface

protocol SessionDetailViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - SessionDetailPresentation

protocol SessionDetailPresentation: AnyObject {
    func handleButtonTap()
}
