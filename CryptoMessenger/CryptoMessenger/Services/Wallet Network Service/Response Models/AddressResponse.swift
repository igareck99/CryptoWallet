import Foundation

struct AddressResponse: Codable {
	let ethereum: [Address]?
	let bitcoin: [Address]?
    let binance: [Address]?
}

struct Address: Codable {
	let address: String
	let publicKey: String
}
