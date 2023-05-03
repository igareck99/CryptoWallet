import Foundation

struct BalanceRequestParams: Codable {
    let currency: FiatCurrency
    let addresses: [NetworkAddress: [WalletBalanceAddress]]

    func makeParamsDict() -> [String: Any] {
        let ethAddress: Array<[String: Any]> = (addresses[.ethereum] ?? []).map({ [
            "accountAddress": $0.accountAddress,
            "tokenAddress": $0.tokenAddress
        ] })
        let btcAddress: Array<[String: Any]> = (addresses[.bitcoin] ?? []).map({ [
            "accountAddress": $0.accountAddress,
            "tokenAddress": $0.tokenAddress
        ] })
        let bncAddress: Array<[String: Any]> = (addresses[.binance] ?? []).map({ [
            "accountAddress": $0.accountAddress,
            "tokenAddress": $0.tokenAddress
        ] })

        let paramsDict: [String: Any] = [
            "currency": currency.rawValue,
            "addresses": [
                "ethereum": ethAddress,
                "bitcoin": btcAddress,
                "binance": bncAddress
            ]
        ]
        return paramsDict
    }
}

struct WalletBalanceAddress: Codable {
	let accountAddress: String
    let tokenAddress: String?

    init (
        accountAddress: String,
        tokenAddress: String? = nil
    ) {
        self.accountAddress = accountAddress
        self.tokenAddress = tokenAddress
    }
}

enum FiatCurrency: String, Codable {
    case usd
    case eur
}

enum NetworkAddress: String, Codable {
    case ethereum
    case bitcoin
    case binance
}
