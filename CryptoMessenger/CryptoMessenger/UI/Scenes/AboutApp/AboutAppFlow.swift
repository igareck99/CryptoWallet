import Foundation

// MARK: - AboutAppFlow

enum AboutAppFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
