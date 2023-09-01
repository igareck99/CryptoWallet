import Foundation

// MARK: - UserReceiverData

struct UserReceiverData: Equatable {

    // MARK: - Internal Properties

    var name: String
    var url: URL?
    var adress: String
    var walletType: WalletType
}
