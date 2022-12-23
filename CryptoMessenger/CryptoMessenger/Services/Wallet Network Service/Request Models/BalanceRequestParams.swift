import Foundation

struct BalanceRequestParams: Codable {
	let ethereum: [WalletBalanceAddress]
	let bitcoin: [WalletBalanceAddress]
}

struct WalletBalanceAddress: Codable {
	let accountAddress: String
}
