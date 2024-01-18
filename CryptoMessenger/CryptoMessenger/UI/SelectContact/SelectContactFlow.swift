import Foundation

// MARK: - SelectContactFlow

enum SelectContactFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case error(APIError)
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
    }
}

// MARK: - ContactViewMode

enum ContactViewMode: Identifiable {

    // MARK: - Types

    case add, admins, send, groupCreate, channelParticipantsAdd

    // MARK: - Internal Properties

    var id: UUID { UUID() }
}
