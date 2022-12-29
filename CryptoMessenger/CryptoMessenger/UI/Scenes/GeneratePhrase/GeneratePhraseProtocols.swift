import Foundation

// MARK: - GeneratePhraseSceneDelegate

protocol GeneratePhraseSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
