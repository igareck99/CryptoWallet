import UIKit

// MARK: - PhotoEditorSceneDelegate

protocol PhotoEditorSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - PhotoEditorViewInterface

protocol PhotoEditorViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - PhotoEditorPresentation

protocol PhotoEditorPresentation: AnyObject {
    var images: [UIImage] { get }

    func handleButtonTap()
}
