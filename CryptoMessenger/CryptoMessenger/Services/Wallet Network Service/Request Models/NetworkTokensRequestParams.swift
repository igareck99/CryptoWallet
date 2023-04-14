import Foundation

struct NetworkTokensRequestParams: Codable {
    let cryptoTypes: [CryptoType]
}

/*
{
    "cryptoTypes": [
        "binance",
        "ethereum",
        "bitcoin"
    ]
}
*/
