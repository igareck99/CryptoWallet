import Foundation

// MARK: - SecuritySceneDelegate

protocol SecuritySceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - SecurityViewInterface

protocol SecurityViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - SecurityPresentation

protocol SecurityPresentation: AnyObject {
    func handleButtonTap()
}
