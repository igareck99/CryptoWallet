import Foundation

// MARK: - FacilityApproveFlow

enum FacilityApproveFlow {

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
        case onTransaction
    }
}
