import Foundation

// MARK: - BlackListFlow

enum BlackListFlow {

    // MARK: - ViewState

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
