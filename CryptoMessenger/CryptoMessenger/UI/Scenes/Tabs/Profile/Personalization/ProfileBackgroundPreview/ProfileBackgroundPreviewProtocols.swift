import Foundation

// MARK: - ProfileBackgroundPreviewSceneDelegate

protocol ProfileBackgroundPreviewSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - ProfileBackgroundPreviewViewInterface

protocol ProfileBackgroundPreviewViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - ProfileBackgroundPreviewPresentation

protocol ProfileBackgroundPreviewPresentation: AnyObject {
    func handleButtonTap()
}
