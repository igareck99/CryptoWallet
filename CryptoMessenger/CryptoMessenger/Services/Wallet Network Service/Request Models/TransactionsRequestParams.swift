import Foundation

struct TransactionsRequestParams: Codable {
	let ethereum: [WalletTransactions]
	let bitcoin: [WalletTransactions]
}

struct WalletTransactions: Codable {
	let address: String
	let limit: String
}
