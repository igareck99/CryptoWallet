import Foundation

// MARK: - SecurityFlow

enum SecurityFlow {

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

        case onBlockList
        case onAppear
        case onCreatePassword
        case onFalsePassword
        case onSession
        case onApprovePassword
        case onImportKey
        case onPhrase
        case onRemovePassword
        case biometryActivate
    }
}
