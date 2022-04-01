import Foundation

// MARK: - SocialListFlow

enum SocialListFlow {

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
    }
}
