import Foundation

// MARK: - TypographyFlow

enum TypographyFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
