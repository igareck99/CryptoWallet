import Foundation

// MARK: - PinCodeSceneDelegate

protocol PinCodeSceneDelegate: AnyObject {
    func handleNextScene()
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
