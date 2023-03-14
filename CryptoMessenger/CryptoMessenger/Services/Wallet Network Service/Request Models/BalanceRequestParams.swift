import Foundation

struct BalanceRequestParams: Codable {
//    let currency: FiatCurrency
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
