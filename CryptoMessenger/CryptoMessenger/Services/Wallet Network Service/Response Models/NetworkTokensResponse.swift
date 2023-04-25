import Foundation

struct NetworkTokensResponse: Codable {
    let binance: [NetworkTokenModel]?
    let ethereum: [NetworkTokenModel]?
    let bitcoin: [NetworkTokenModel]?
}

struct NetworkTokenModel: Codable {
    let address: String?
    let contractType: String?
    let decimals: Int16
    let symbol: String
    let name: String
}
