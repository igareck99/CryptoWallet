import Foundation

// MARK: - KeyImportSceneDelegate

protocol KeyImportSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - KeyImportViewInterface

protocol KeyImportViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - KeyImportPresentation

protocol KeyImportPresentation: AnyObject {
    func handleImportButtonTap()
}
