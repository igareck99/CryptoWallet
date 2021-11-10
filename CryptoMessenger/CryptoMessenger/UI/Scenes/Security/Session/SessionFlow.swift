import Foundation

// MARK: - SessionFlow

enum SessionFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
