import Foundation

// MARK: - WalletType

enum WalletType: String {

	case ethereum
	case bitcoin
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
		}
	}
}
