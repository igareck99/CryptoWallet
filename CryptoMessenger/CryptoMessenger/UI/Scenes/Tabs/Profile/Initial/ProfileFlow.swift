import UIKit

// MARK: - ProfileFlow

enum ProfileFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result([UIImage?])
        case error(message: String)
    }
}
