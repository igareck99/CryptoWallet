import Foundation

// MARK: - KeyImportFlow

enum KeyImportFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
