import Foundation

struct AddressRequestParams: Codable {
	let ethereum: [WalletPublic]
	let bitcoin: [WalletPublic]
}

struct WalletPublic: Codable {
	let publicKey: String
}
