import Foundation

// MARK: - SecurityPinCodeFlow

enum SecurityPinCodeFlow {

    // MARK: - ViewState

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
