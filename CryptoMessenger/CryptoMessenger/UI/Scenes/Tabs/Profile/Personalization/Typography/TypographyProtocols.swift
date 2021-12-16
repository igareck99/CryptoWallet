import Foundation

// MARK: - TypographySceneDelegate

protocol TypographySceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - TypographyViewInterface

protocol TypographyViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - TypographyPresentation

protocol TypographyPresentation: AnyObject {
    func handleButtonTap()
}
