import Foundation

// MARK: - ChatFlow

enum ChatFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
