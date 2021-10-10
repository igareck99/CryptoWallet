import Foundation

// MARK: - PinCodeFlow

enum PinCodeFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result(AvailableBiometric?)
        case error(message: String)
    }
}
