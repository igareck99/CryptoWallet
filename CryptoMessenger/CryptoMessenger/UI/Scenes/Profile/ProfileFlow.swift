import Foundation

// MARK: - ProfileFlow

enum ProfileFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
