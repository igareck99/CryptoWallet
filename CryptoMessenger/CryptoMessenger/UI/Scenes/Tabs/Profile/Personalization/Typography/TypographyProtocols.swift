import Foundation

// MARK: - TypographySceneDelegate

protocol TypographySceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - TypographyViewInterface

protocol TypographyViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - TypographyPresentation

protocol TypographyPresentation: AnyObject {
    func handleButtonTap()
}
