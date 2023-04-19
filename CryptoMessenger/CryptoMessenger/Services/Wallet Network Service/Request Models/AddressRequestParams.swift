import Foundation

struct AddressRequestParams: Codable {
	let ethereum: [WalletPublic]
	let bitcoin: [WalletPublic]
    let binance: [WalletPublic]
}

struct WalletPublic: Codable {
	let publicKey: String
}
