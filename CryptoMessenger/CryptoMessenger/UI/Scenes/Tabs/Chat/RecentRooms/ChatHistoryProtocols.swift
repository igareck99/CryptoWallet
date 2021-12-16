import Foundation

// MARK: - ChatHistorySceneDelegate

protocol ChatHistorySceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
