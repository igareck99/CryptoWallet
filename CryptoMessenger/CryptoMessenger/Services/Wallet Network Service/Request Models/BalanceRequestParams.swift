import Foundation

struct BalanceRequestParamsV2: Codable {
    let currency: FiatCurrency
    let addresses: [NetworkAddress: [WalletBalanceAddress]]
}

struct BalanceRequestParams: Codable {
	let ethereum: [WalletBalanceAddress]
	let bitcoin: [WalletBalanceAddress]
    let binance: [WalletBalanceAddress]
}

struct WalletBalanceAddress: Codable {
	let accountAddress: String
    let tokenAddress: String?
    
    init (
        accountAddress: String,
        tokenAddress: String? = nil
    ) {
        self.accountAddress = accountAddress
        self.tokenAddress = tokenAddress
    }
}

enum FiatCurrency: String, Codable {
    case usd
    case eur
}

enum NetworkAddress: String, Codable {
    case ethereum
    case bitcoin
    case binance
}
