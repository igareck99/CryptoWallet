import Foundation

// MARK: - SessionFlow

enum SessionFlow {

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
        case onDeleteAll
        case onDeleteOne(deviceId: String)
    }
}
