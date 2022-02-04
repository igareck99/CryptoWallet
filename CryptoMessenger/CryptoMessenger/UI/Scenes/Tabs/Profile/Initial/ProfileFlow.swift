import Foundation

// MARK: - ProfileFlow

enum ProfileFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case error(message: String)
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
        case onProfileScene
        case onPersonalization
        case onSecurity
        case aboutApp
        case onFAQ
    }
}
