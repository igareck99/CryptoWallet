import Foundation

struct TransactionTemplateResponse: Codable {
	let hashes: [TransactionTemplateHash]
	let uuid: String
}

struct TransactionTemplateHash: Codable {
	let index: Int
	let hash: String
}
