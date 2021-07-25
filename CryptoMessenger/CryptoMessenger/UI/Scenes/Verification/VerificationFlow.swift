import Foundation

// MARK: - VerificationFlow

enum VerificationFlow {

    // MARK: - Types

    enum ViewState {
        case idle(String)
        case sending
        case resend(String, Bool)
        case result
        case error(message: String)
    }
}
