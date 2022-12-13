import Foundation

struct TransactionSendRequestParams: Codable {
	let signatures: [TransactionSendRequestSignature]
	let uuid: String
	let cryptoType: String
}

struct TransactionSendRequestSignature: Codable {
	let index: Int
	let derSignature: String
}
