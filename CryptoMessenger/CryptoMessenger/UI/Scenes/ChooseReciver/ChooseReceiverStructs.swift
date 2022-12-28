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

// MARK: - UserWallletData

struct UserWallletData: Hashable {

    // MARK: - Internal Properties

    let name: String
    let bitcoin: String
    let ethereum: String
    let url: URL?
    let phone: String
}

// MARK: - UserReceiverData

struct UserReceiverData: Equatable {

    // MARK: - Internal Properties

    var name: String
    var url: URL?
    var adress: String
    var walletType: WalletType
}

// MARK: - AdressesData

struct AdressesData {

    // MARK: - Internal Properties

    var eth: String
    var btc: String

    // MARK: - Internal Methods

    func getDataForPatchAssets() -> [String: [String: String]] {
        return ["ethereum": [
            "address": self.eth
          ],
          "bitcoin": [
            "address": self.btc
          ]
        ]
    }
}
