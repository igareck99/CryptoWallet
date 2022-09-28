import Foundation
import UIKit

// MARK: - FriendProfileFlow

enum FriendProfileFlow {

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
        case onProfileAppear
        case onShow(ProfileSettingsMenu)
        case onSocial
    }
}
