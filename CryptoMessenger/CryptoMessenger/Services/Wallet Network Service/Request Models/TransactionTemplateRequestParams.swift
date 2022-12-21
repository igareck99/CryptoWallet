import Foundation

struct TransactionTemplateRequestParams: Codable {
	let publicKey: String
	let addressTo: String
	let amount: String
	let fee: String
	let cryptoType: String
}
