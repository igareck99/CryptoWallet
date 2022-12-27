import Foundation

struct TransactionsRequestParams: Codable {
	var ethereum: [WalletTransactions]
	var bitcoin: [WalletTransactions]
}

struct WalletTransactions: Codable {
	let address: String
	let limit: String
	let date: String?

	init(
		address: String,
		limit: String = "10",
		date: String? = nil
	) {
		self.address = address
		self.limit = limit
		self.date = date
	}
}
