import Foundation

// MARK: - WalletNewFlow

enum WalletNewFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case error(message: String)
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
        case onImportKey
        case onTransfer
        case onTransactionToken(selectorTokenIndex: Int)
        case onTransactionType(selectorFilterIndex: Int)
        case onTransactionAddress(selectorTokenIndex: Int, address: String)
    }
}
