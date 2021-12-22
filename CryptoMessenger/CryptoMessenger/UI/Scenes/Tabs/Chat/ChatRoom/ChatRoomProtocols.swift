import Foundation

// MARK: - ChatRoomSceneDelegate

protocol ChatRoomSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
