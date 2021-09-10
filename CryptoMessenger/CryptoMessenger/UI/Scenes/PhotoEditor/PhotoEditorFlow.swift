import Foundation

// MARK: - PhotoEditorFlow

enum PhotoEditorFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
