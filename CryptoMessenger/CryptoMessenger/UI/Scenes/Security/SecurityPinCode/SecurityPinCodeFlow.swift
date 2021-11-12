import Foundation

// MARK: - SecurityPinCodeFlow

enum SecurityPinCodeFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
