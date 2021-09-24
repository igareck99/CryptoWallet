import Foundation

// MARK: - FriendProfileFlow

enum FriendProfileFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
