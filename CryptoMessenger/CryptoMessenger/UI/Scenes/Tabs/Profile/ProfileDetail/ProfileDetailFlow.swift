import Foundation

// MARK: - ProfileDetailFlow

enum ProfileDetailFlow {

    // MARK: - Types

    enum ViewState {

        // MARK: - Types

        case sending
        case result
        case error(message: String)
    }
}
