import Foundation

// MARK: - PersonalizationSceneDelegate

protocol PersonalizationSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - PersonalizationViewInterface

protocol PersonalizationViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - PersonalizationPresentation

protocol PersonalizationPresentation: AnyObject {
    func handleButtonTap()
}
