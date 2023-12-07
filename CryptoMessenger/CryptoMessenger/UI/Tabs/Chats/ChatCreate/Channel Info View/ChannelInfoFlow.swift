import Foundation

// MARK: - ChannelInfoFlow

enum ChannelInfoFlow {

    // MARK: - ViewState

    enum ViewState: Equatable {
        case idle
        case loading
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
        case onMedia(String)
    }
}
