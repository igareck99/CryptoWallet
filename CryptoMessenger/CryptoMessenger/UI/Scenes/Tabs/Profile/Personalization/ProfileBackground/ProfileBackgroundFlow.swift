import UIKit

// MARK: - ProfileBackgroundFlow

enum ProfileBackgroundFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result([UIImage?])
        case error(message: String)
    }
}
