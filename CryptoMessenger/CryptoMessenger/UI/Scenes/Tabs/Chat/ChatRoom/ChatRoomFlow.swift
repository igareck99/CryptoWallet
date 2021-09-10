import Foundation

// MARK: - ChatRoomFlow

enum ChatRoomFlow {

    // MARK: - Types

    enum ViewState {
        case idle
        case loading
        case error(message: String)
    }

    enum Event {
        case onAppear
        case onSend(MessageType)
        case onAddReaction(messageId: String, reactionId: String)
        case onDeleteReaction(messageId: String, reactionId: String)
        case onNextScene
    }
}
