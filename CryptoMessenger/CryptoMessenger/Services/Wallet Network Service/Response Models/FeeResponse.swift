import Foundation

struct FeeResponse: Codable {
	let cryptoType: String
	let fee: CryptoFee
}

struct CryptoFee: Codable {
	let slow: String
	let average: String
	let fast: String
}
