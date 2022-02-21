import Foundation

// MARK: - ChatCreateFlow

enum ChatCreateFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case error(APIError)
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
        case onNextScene
        case onCreateDirect([String])
        case onCreateGroup(ChatData)
    }
}
