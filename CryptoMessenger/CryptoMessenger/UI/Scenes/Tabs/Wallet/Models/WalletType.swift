import Foundation

// MARK: - WalletType

enum WalletType: String {

	case ethereum
	case bitcoin
    case binance
	case aur

	// MARK: - Internal Properties

	var result: String {
		switch self {
		case .ethereum:
			return R.string.localizable.transactionETHFilter()
		case .aur:
			return R.string.localizable.transactionAURFilter()
		case .bitcoin:
			return "BTC"
        case .binance:
            return "BNC"
		}
	}

	var chooseTitle: String {
		switch self {
		case .ethereum:
			return R.string.localizable.transactionETHFilter()
		case .aur:
			return R.string.localizable.transactionAURFilter()
		case .bitcoin:
			return "BTC (Bitcoin)"
        case .binance:
            return "Binance"
		}
	}

	var abbreviatedName: String {
		switch self {
		case .ethereum:
			return "ETH"
		case .aur:
			return "AUR"
		case .bitcoin:
			return "BTC"
        case .binance:
            return "BNC"
		}
	}
}
