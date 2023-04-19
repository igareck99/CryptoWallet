import Foundation

enum WalletType: String {

    case binance
    case binanceUSDT
    case binanceBUSD
	case ethereum
    case ethereumUSDT
    case ethereumUSDC
	case bitcoin
	case aur

	var networkTitle: String {
		switch self {
		case .ethereum, .ethereumUSDT, .ethereumUSDC:
			return R.string.localizable.walletEthereum()
		case .aur:
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
		case .aur:
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
        case .aur:
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
        case .aur:
            return R.string.localizable.walletAura()
        case .bitcoin:
            return R.string.localizable.walletBitcoin()
        }
    }

    var compositeTitle: String {
        switch self {
        case .aur:
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
