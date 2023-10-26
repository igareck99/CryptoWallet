import Foundation

struct BalancesResponse: Codable {
	let ethereum: [Balance]
	let bitcoin: [Balance]
    let binance: [Balance]
    let aura: [Balance]
}

struct Balance: Codable {
	let accountAddress: String
	let tokenAddress: String?
	let amount: String
    let fiatPrice: Double?
}
