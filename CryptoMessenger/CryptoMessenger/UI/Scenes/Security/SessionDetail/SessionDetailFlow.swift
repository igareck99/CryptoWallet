import Foundation

// MARK: - SessionDetailFlow

enum SessionDetailFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
