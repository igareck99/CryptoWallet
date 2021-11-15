import Foundation

// MARK: - ChatHistorySceneDelegate

protocol ChatHistorySceneDelegate: AnyObject {
    func handleRoomTap(_ room: AuraRoom)
}
