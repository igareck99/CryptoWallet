import Foundation

// MARK: - CallListFlow

enum CallListFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
