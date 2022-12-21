import Foundation

struct FacilityApproveModel: Codable {
	let reciverName: String?
	let reciverAddress: String?
	let transferAmount: String
	let transferCurrency: String
	let comissionAmount: String
	let comissionCurrency: String

	let signedTransactions: [SignedTransaction]
	let uuid: String
	let cryptoType: String
}

struct SignedTransaction: Codable {
	let derSignature: String
	let index: Int
}
