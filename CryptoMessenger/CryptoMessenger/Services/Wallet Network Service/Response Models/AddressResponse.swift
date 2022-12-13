import Foundation

struct AddressResponse: Codable {
	let ethereum: [Address]?
	let bitcoin: [Address]?
}

struct Address: Codable {
	let address: String
	let publicKey: String
}
