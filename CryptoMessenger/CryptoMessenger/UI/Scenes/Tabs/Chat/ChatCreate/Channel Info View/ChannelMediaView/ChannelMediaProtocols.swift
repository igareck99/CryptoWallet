import Foundation

// MARK: - ChannelMediaSceneDelegate

protocol ChannelMediaSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
