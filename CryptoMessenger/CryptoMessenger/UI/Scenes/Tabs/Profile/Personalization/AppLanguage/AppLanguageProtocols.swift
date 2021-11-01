import Foundation

// MARK: - AppLanguageSceneDelegate

protocol AppLanguageSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - AppLanguageViewInterface

protocol AppLanguageViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - AppLanguagePresentation

protocol AppLanguagePresentation: AnyObject {
    func handleButtonTap()
}
