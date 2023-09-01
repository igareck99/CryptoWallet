import Foundation


// MARK: - SearchType

enum SearchType {

    // MARK: - Types

    case telephone
    case wallet

    // MARK: - Internal Properties

    var result: String {
        switch self {
        case .telephone:
            return R.string.localizable.chooseReceiverTelephone()
        case .wallet:
            return R.string.localizable.chooseReceiverWallet()
        }
    }
}
