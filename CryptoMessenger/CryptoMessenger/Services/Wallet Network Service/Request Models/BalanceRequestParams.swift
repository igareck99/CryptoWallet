import Foundation

struct BalanceRequestParamsV2: Codable {
    let currency: FiatCurrency
    let addresses: [NetworkAddress: [WalletBalanceAddress]]
}

struct BalanceRequestParams: Codable {
	let ethereum: [WalletBalanceAddress]
	let bitcoin: [WalletBalanceAddress]
}

struct WalletBalanceAddress: Codable {
	let accountAddress: String
}

enum FiatCurrency: String, Codable {
    case usd
    case eur
}

enum NetworkAddress: String, Codable {
    case ethereum
    case bitcoin
}
