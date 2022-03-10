import Foundation

// MARK: - TransactionSceneDelegate

protocol TransactionSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
}
