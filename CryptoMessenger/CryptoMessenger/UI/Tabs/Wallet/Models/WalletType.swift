import Foundation

enum WalletType: String {
    
    case bitcoin
    case ethereum
    case aura
    case binance
    case binanceUSDT
    case binanceBUSD
    case ethereumUSDT
    case ethereumUSDC
    
    var order: Int {
        switch self {
        case .bitcoin:
            return 0
        case .ethereum:
            return 1
        case .aura:
            return 2
        case .binance:
            return 5
        case .binanceUSDT:
            return 6
        case .binanceBUSD:
            return 7
        case .ethereumUSDT:
            return 3
        case .ethereumUSDC:
            return 4
        }
    }

	var networkTitle: String {
		switch self {
		case .ethereum, .ethereumUSDT, .ethereumUSDC:
			return R.string.localizable.walletEthereum()
		case .aura:
			return R.string.localizable.walletAura()
		case .bitcoin:
			return R.string.localizable.walletBitcoin()
        case .binance, .binanceUSDT, .binanceBUSD:
            return R.string.localizable.walletBinance()
		}
	}

	var currency: String {
		switch self {
        case .binanceUSDT, .ethereumUSDT:
            return R.string.localizable.walletUSDT()
        case .ethereumUSDC:
            return R.string.localizable.walletUSDC()
        case .binanceBUSD:
            return R.string.localizable.walletBUSD()
		case .ethereum:
            return R.string.localizable.walletETH()
		case .aura:
            return R.string.localizable.walletAUR()
		case .bitcoin:
            return R.string.localizable.walletBTC()
        case .binance:
            return R.string.localizable.walletBNB()
		}
	}

    var feeCurrency: String {
        switch self {
        case .ethereum, .ethereumUSDT, .ethereumUSDC:
            return R.string.localizable.walletETH()
        case .binance, .binanceUSDT, .binanceBUSD:
            return R.string.localizable.walletBNB()
        case .aura:
            return R.string.localizable.walletAUR()
        case .bitcoin:
            return R.string.localizable.walletBTC()
        }
    }

    var feeWalletType: String {
        switch self {
        case .ethereum, .ethereumUSDT, .ethereumUSDC:
            return R.string.localizable.walletEthereum()
        case .binance, .binanceUSDT, .binanceBUSD:
            return R.string.localizable.walletBinance()
        case .aura:
            return R.string.localizable.walletAura()
        case .bitcoin:
            return R.string.localizable.walletBitcoin()
        }
    }

    var compositeTitle: String {
        switch self {
        case .aura:
            return R.string.localizable.walletAuraAUR()
        case .bitcoin:
            return R.string.localizable.walletBitcoinBTC()
        case .ethereum:
            return R.string.localizable.walletEthereumETH()
        case .ethereumUSDT:
            return R.string.localizable.walletEthereumUSDT()
        case .ethereumUSDC:
            return R.string.localizable.walletEthereumUSDC()
        case .binance:
            return R.string.localizable.walletBinanceBNB()
        case .binanceBUSD:
            return R.string.localizable.walletBinanceBUSD()
        case .binanceUSDT:
            return R.string.localizable.walletBinanceUSDT()
        }
    }
}
