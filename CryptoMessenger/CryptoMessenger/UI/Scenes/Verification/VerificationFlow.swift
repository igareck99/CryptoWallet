import Foundation

// MARK: - VerificationFlow

enum VerificationFlow {

    // MARK: - Types

    enum ViewState {
        case idle(String)
        case sending
        case result
        case error(message: String)
    }
}
