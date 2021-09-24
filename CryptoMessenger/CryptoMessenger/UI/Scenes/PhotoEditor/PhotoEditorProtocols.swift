import Foundation

// MARK: - PhotoEditorSceneDelegate

protocol PhotoEditorSceneDelegate: AnyObject {
    func handleButtonTap()
}

// MARK: - PhotoEditorViewInterface

protocol PhotoEditorViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - PhotoEditorPresentation

protocol PhotoEditorPresentation: AnyObject {
    func handleButtonTap()
}