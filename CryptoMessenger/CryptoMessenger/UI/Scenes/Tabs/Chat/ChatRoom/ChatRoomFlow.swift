import Foundation

// MARK: - ChatRoomFlow

enum ChatRoomFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case error(message: String)
    }


    // MARK: - Event

    enum Event {
        
        // MARK: - Types

        case onAppear
        case onSend(MessageType)
        case onAddReaction(messageId: String, reactionId: String)
        case onDeleteReaction(messageId: String, reactionId: String)
        case onNextScene
    }
}
