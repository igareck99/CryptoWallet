import Foundation

// MARK: - AboutAppSceneDelegate

protocol AboutAppSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - AboutAppViewInterface

protocol AboutAppViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - AboutAppPresentation

protocol AboutAppPresentation: AnyObject {
    func handleButtonTap()
}
