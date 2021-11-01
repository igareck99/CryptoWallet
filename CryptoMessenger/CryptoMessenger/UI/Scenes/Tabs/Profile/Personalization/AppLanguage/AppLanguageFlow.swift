import Foundation

// MARK: - AppLanguageFlow

enum AppLanguageFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
