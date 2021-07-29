import Foundation

// MARK: - WalletFlow

enum WalletFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
