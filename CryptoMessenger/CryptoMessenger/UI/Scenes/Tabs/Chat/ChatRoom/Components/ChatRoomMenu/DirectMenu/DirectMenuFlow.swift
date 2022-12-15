import Foundation
import UIKit
import SwiftUI

// MARK: - DirectMenuFlow

enum DirectMenuFlow {

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
        case onChatMedia(room: AuraRoom)
    }
}
