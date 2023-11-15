import Foundation

enum CryptoType: String, Codable {
	case ethereum
	case bitcoin
    case binance
    case aura
}

struct WalletNetworkResponse: Codable {
	let ethereum: WalletNetworkModel?
	let bitcoin: WalletNetworkModel?
    let binance: WalletNetworkModel?
    let aura: WalletNetworkModel?
}

struct WalletNetworkModel: Codable {
	let lastUpdate: String
	let cryptoType: String
	let name: String
	let derivePath: String
    let explorerUrl: String
	let token: WalletNetworkTokenModel
}

struct WalletNetworkTokenModel: Codable {
	let address: String
	let contractType: String?
	let decimals: Int16
	let symbol: String
	let name: String
}
