import Foundation

// MARK: - OnboardingFlow

enum OnboardingFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
