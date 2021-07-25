import Foundation

// MARK: - GenerationInfoFlow

enum GenerationInfoFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
