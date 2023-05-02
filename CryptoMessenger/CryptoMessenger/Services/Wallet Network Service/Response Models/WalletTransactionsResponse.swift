import Foundation

struct WalletsTransactionsResponse: Codable {
	let ethereum: [String: [CryptoTransaction]]?
	let bitcoin: [String: [CryptoTransaction]]?
    let binance: [String: [CryptoTransaction]]?
}


struct CryptoTransaction: Codable {
	let hash: String
	let block: Int?
	let time: String?
	let tokenAddress: String?
	let cryptoType: String
	let inputs: [InputOutput]
	let outputs: [InputOutput]
	let status: String
}

struct InputOutput: Codable {
	let address: String
	let value: String
}
