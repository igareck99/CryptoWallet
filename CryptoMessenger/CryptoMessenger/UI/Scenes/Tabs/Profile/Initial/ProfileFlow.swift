import Foundation

// MARK: - ProfileFlow

enum ProfileFlow {

    // MARK: - Types

    enum ViewState {
        case idle
        case loading
        case error(message: String)
    }

    enum Event {
        case onAppear
        case onNextScene
    }
}
