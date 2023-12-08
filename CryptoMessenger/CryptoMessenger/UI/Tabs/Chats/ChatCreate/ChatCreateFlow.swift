import Foundation

// MARK: - ChatCreateFlow

enum ChatCreateFlow {

    // MARK: - ViewState

	enum ViewState: Equatable {
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
    }
}
