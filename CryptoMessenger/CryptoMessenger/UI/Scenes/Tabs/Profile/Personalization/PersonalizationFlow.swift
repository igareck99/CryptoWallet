import Foundation

// MARK: - PersonalizationFlow

enum PersonalizationFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
