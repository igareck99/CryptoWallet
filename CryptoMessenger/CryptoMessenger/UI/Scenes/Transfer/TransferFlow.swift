import Foundation

// MARK: - TransferFlow

enum TransferFlow {

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
        case onChooseReceiver
        case onApprove
    }
}
