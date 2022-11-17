import Foundation

struct WalletNetworkModel: Codable {
	let lastUpdate: String
	let cryptoType: String
	let name: String
	let derivePath: String
	let token: WalletNetworkTokenModel
}
