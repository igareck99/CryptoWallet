import Foundation

// MARK: - BlackListFlow

enum BlackListFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
