import Foundation

// MARK: - WalletFlow

enum WalletFlow {

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
		case onImportPhrase
        case onImportKey
        case onTransfer
        case onTransactionToken(selectorTokenIndex: Int)
        case onTransactionType(selectorFilterIndex: Int)
        case onTransactionAddress(selectorTokenIndex: Int, address: String)
    }
}
