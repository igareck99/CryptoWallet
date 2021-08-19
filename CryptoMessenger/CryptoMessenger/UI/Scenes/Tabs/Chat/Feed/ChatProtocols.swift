import Foundation

// MARK: - ChatSceneDelegate

protocol ChatSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - ChatViewInterface

protocol ChatViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - ChatPresentation

protocol ChatPresentation: AnyObject {
    func handleButtonTap()
}
