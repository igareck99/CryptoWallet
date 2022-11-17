import Foundation

struct WalletNetworkTokenModel: Codable {
	let address: String
	let contractType: String?
	let decimals: UInt
	let symbol: String
	let name: String
}
