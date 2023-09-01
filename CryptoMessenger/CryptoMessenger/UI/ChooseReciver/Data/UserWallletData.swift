import SwiftUI

// MARK: - UserWallletData

struct UserWallletData: Identifiable, Hashable, ViewGeneratable {

    // MARK: - Internal Properties

    var id = UUID()
    let name: String
    let bitcoin: String
    let ethereum: String
    let binance: String
    let url: URL?
    let phone: String
    let searchType: SearchType
    let walletType: WalletType
    let onTap: (UserWallletData) -> Void

    // MARK: - Lifecycle

    init(name: String, bitcoin: String,
         ethereum: String, binance: String,
         url: URL?, phone: String, searchType: SearchType = .telephone,
         walletType: WalletType,
         onTap: @escaping (UserWallletData) -> Void) {
        self.name = name
        self.bitcoin = bitcoin
        self.ethereum = ethereum
        self.binance = binance
        self.url = url
        self.phone = phone
        self.searchType = searchType
        self.walletType = walletType
        self.onTap = onTap
    }

    func view() -> AnyView {
        ReceiverRowView(data: self).anyView()
    }
}
