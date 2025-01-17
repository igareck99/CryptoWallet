import Foundation

// MARK: - TransactionInfo

struct TransactionInfo: Identifiable, Hashable, Equatable {

	// MARK: - Internal Properties

	let id = UUID()
	let type: TransactionType
	let date: String
	let transactionCoin: WalletType
	let transactionResult: String
	let amount: String
	let from: String
    
    var sign: String {
        type == .send ? "-" : "+"
    }

	static let mock = TransactionInfo(
		type: .send,
		date: "Jan 01",
		transactionCoin: .ethereum,
		transactionResult: "SUCCESS",
		amount: "-0.001",
		from: "0xty9 ... Bx9M"
	)
}
