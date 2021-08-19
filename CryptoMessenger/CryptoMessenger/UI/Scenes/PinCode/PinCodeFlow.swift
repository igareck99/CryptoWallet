import Foundation

// MARK: - PinCodeFlow

enum PinCodeFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result(AvailableBiometrics?)
        case error(message: String)
    }
}
