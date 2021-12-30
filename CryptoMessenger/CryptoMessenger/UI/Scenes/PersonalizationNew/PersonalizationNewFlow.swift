import Foundation

// MARK: - PersonalizationNewFlow

enum PersonalizationNewFlow {

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
        case onProfile
        case onLanguage
        case onTypography
        case onSelectBackground
        case backgroundPreview
    }
}
