import Foundation

// MARK: - TransactionInfo

struct TransactionInfo: Identifiable, Equatable {

	// MARK: - Internal Properties

	let id = UUID()
	let type: TransactionType
	let date: String
	let transactionCoin: WalletType
	let transactionResult: String
	let amount: String
	let from: String

	init(
		type: TransactionType = .send,
		date: String = "Jan 01",
		from: String = "0xty9 ... Bx9M",
		transactionCoin: WalletType = .ethereum,
		transactionResult: String = "SUCCESS",
		amount: String = "-0.001"
	) {
		self.type = type
		self.date = date
		self.from = from
		self.transactionCoin = transactionCoin
		self.transactionResult = transactionResult
		self.amount = amount
	}
}
