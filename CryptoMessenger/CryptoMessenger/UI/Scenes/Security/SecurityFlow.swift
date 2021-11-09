import Foundation

// MARK: - SecurityFlow

enum SecurityFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
