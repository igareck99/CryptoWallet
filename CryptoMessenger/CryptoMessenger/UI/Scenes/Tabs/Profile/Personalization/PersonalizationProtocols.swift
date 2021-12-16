import Foundation

// MARK: - PersonalizationSceneDelegate

protocol PersonalizationSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - PersonalizationViewInterface

protocol PersonalizationViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - PersonalizationPresentation

protocol PersonalizationPresentation: AnyObject {
    func handleButtonTap()
}
