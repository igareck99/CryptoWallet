import SwiftUI

// MARK: - TransferFlow

enum TransferFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case showContent
        case error(APIError)
        case contactsAccessFailure
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
        case onChooseReceiver(Binding<String>)
        case onApprove
    }
}
