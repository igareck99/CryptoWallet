import Foundation
// swiftlint: disable: all
struct TransactionsRequestParams: Codable {
    let walletTransactions: [WalletTransactions]

    func makeRequestDict() -> [String: Any] {
        let result = walletTransactions
            .reduce(into: [String: [[String: Any]]]()) { partialResult, transaction in
                var transactions = partialResult[transaction.cryptoType.rawValue] ?? [[String: Any]]()
                transactions.append(transaction.dictionary)
                partialResult[transaction.cryptoType.rawValue] = transactions
            }
        return result
    }
}

struct WalletTransactions: Codable {
    let cryptoType: CryptoType
	let address: String
    let tokenAddress: String?
	let limit: String
	let date: String?

	init(
        cryptoType: CryptoType,
		address: String,
        tokenAddress: String? = "",
		limit: String = "10",
		date: String? = nil
	) {
        self.cryptoType = cryptoType
		self.address = address
        self.tokenAddress = tokenAddress
		self.limit = limit
		self.date = date
	}
}
