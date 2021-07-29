import Foundation

// MARK: - ProfileSceneDelegate

protocol ProfileSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - ProfileViewInterface

protocol ProfileViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - ProfilePresentation

protocol ProfilePresentation: AnyObject {
    func handleButtonTap()
}
