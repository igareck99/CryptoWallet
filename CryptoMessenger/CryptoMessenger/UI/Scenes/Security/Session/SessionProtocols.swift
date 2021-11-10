import Foundation

// MARK: - SessionSceneDelegate

protocol SessionSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - SessionViewInterface

protocol SessionViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - SessionPresentation

protocol SessionPresentation: AnyObject {
    func handleButtonTap()
}
