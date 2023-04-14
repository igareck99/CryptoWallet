import Foundation

struct NetworkTokensResponse: Codable {
    let binance: [NetworkToken]?
    let ethereum: [NetworkToken]?
    let bitcoin: [NetworkToken]?
}

struct NetworkToken: Codable {
    let address: String
    let contractType: String?
    let decimals: Int
    let symbol: String
    let name: String
}

/*
{
  "binance": [
    {
      "address": "0x55d398326f99059ff775485246999027b3197955",
      "contractType": "ERC20",
      "decimals": 18,
      "symbol": "USDT",
      "name": "Binance-Peg BSC-USD"
    },
    {
      "address": "0xe9e7cea3dedca5984780bafc599bd69add087d56",
      "contractType": "ERC20",
      "decimals": 18,
      "symbol": "BUSD",
      "name": "Binance-Peg BUSD Token"
    }
  ],
  "bitcoin": [
    {
      "address": "",
      "contractType": null,
      "decimals": 8,
      "symbol": "BTC",
      "name": "Bitcoin"
    }
  ],
  "ethereum": [
    {
      "address": "0xdac17f958d2ee523a2206206994597c13d831ec7",
      "contractType": "ERC20",
      "decimals": 6,
      "symbol": "USDT",
      "name": "Tether USD"
    },
    {
      "address": "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
      "contractType": "ERC20",
      "decimals": 18,
      "symbol": "USDC",
      "name": "USD Coin"
    }
  ]
}
*/
