import Foundation
import UIKit
import SwiftUI

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
        case onProfileAppear
        case onShow(ProfileSettingsMenu)
        case onAddPhoto(UIImage)
        case onSocial
        case onShowProfileDetail(Binding<UIImage?>)
    }
}
