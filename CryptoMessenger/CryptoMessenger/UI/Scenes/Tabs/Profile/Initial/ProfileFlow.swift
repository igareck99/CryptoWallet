import Foundation
import UIKit

// MARK: - ProfileFlow

enum ProfileFlow {

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
        case onShow(ProfileSettingsMenu)
        case onAddPhoto(UIImage)
        case onSocial
    }
}
