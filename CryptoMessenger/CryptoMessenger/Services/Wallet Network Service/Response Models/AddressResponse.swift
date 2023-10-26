import Foundation

struct AddressResponse: Codable {
	let ethereum: [Address]?
	let bitcoin: [Address]?
    let binance: [Address]?
    let aura: [Address]?
}

struct Address: Codable {
	let address: String
	let publicKey: String
}
