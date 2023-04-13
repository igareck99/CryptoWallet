import Foundation

enum CryptoType: String, Codable {
	case ethereum
	case bitcoin
    case binance
}

struct WalletNetworkResponse: Codable {
	let ethereum: WalletNetworkModel
	let bitcoin: WalletNetworkModel
    let binance: WalletNetworkModel
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


/*
{
    "ethereum": {
        "lastUpdate": "2023-04-13T11:08:00Z",
        "cryptoType": "ethereum",
        "name": "Ethereum",
        "token": {
            "address": "",
            "contractType": null,
            "decimals": 18,
            "symbol": "ETH",
            "name": "Ethereum"
        },
        "derivePath": "m/44'/60'/0'/0/",
        "explorerUrl": "https://etherscan.io/tx/"
    },
    "binance": {
        "lastUpdate": "2023-04-13T11:08:06Z",
        "cryptoType": "binance",
        "name": "Binance",
        "token": {
            "address": "",
            "contractType": null,
            "decimals": 18,
            "symbol": "BNB",
            "name": "Binance"
        },
        "derivePath": "m/44'/60'/0'/0/",
        "explorerUrl": "https://mainnet.bscscan.com/tx/"
    },
    "bitcoin": {
        "lastUpdate": "2023-04-13T11:08:04Z",
        "cryptoType": "bitcoin",
        "name": "Bitcoin",
        "token": {
            "address": "",
            "contractType": null,
            "decimals": 8,
            "symbol": "BTC",
            "name": "Bitcoin"
        },
        "derivePath": "m/44'/0'/0'/0/",
        "explorerUrl": "https://live.blockcypher.com/btc/tx/"
    }
}
*/
