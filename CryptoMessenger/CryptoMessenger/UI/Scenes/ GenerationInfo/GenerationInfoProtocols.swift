import Foundation

// MARK: - GenerationInfoSceneDelegate

protocol GenerationInfoSceneDelegate: AnyObject {
    func handleNextScene(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - KeyGenerationViewInterface

protocol KeyGenerationViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - KeyGenerationPresentation

protocol KeyGenerationPresentation: AnyObject {
    func handleButtonTap()
}
