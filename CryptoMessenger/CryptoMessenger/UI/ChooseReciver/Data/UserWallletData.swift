import SwiftUI

// MARK: - UserWallletData

struct UserWallletData: Identifiable, Hashable, ViewGeneratable {

    // MARK: - Internal Properties

    var id = UUID()
    let name: String
    // Адреса кошельков
    let bitcoin: String
    let ethereum: String
    let binance: String
    let aura: String
    let url: URL?
    let phone: String
    let searchType: SearchType
    let walletType: WalletType
    let onTap: (UserWallletData) -> Void

    // MARK: - Lifecycle

    init(
        name: String,
        bitcoin: String,
        ethereum: String,
        binance: String,
        aura: String,
        url: URL?,
        phone: String,
        searchType: SearchType = .telephone,
        walletType: WalletType,
        onTap: @escaping (UserWallletData) -> Void
    ) {
        self.name = name
        self.bitcoin = bitcoin
        self.ethereum = ethereum
        self.binance = binance
        self.aura = aura
        self.url = url
        self.phone = phone
        self.searchType = searchType
        self.walletType = walletType
        self.onTap = onTap
    }

    func view() -> AnyView {
        ReceiverRowView(data: self).anyView()
    }

    static let mock = UserWallletData(
        name: .empty,
        bitcoin: .empty,
        ethereum: .empty,
        binance: .empty,
        aura: .empty,
        url: nil,
        phone: .empty,
        searchType: .wallet,
        walletType: .aura,
        onTap: { _ in }
    )
}
