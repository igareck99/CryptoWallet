import Foundation

// MARK: - ProfileDetailFlow

enum ProfileDetailFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
