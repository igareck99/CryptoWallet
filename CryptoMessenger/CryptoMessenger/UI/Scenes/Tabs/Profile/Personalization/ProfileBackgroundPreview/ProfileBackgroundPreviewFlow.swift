import Foundation

// MARK: - ProfileBackgroundPreviewFlow

enum ProfileBackgroundPreviewFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
