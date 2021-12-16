import Foundation

// MARK: - ChatHistoryFlow

enum ChatHistoryFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case result([Message])
        case error(message: String)
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
        case onShowRoom(AuraRoom)
        case onDeleteRoom(String)
    }
}
