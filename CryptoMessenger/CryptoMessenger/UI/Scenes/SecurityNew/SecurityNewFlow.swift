import Foundation

// MARK: - SecurityNewFlow

enum SecurityNewFlow {

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

        case onBlockList
        case onAppear
    }
}
