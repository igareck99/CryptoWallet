import Foundation

enum CryptoType: String {
	case ethereum
	case bitcoin
}

struct WalletNetworkResponse: Codable {
	let ethereum: WalletNetworkModel
	let bitcoin: WalletNetworkModel
}

struct WalletNetworkModel: Codable {
	let lastUpdate: String
	let cryptoType: String
	let name: String
	let derivePath: String
	let token: WalletNetworkTokenModel
}

struct WalletNetworkTokenModel: Codable {
	let address: String
	let contractType: String?
	let decimals: Int16
	let symbol: String
	let name: String
}
