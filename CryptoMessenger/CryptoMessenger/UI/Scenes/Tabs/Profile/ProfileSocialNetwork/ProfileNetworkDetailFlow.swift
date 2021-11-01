import Foundation

// MARK: - ProfileNetworkDetailFlow

enum ProfileNetworkDetailFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
