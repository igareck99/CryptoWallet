import Foundation
import UIKit
import SwiftUI

// MARK: - SettingsFlow

enum SettingsFlow {

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
        case onFriendProfile(userId: Contact)
        case onMedia
    }
}
