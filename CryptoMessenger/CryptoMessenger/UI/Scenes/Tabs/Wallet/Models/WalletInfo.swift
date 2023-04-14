import SwiftUI

// MARK: - TransactionType

enum TransactionType {

	case send
	case receive
}

// MARK: - WalletInfo

struct WalletInfo: Identifiable, Equatable, Hashable {

	// MARK: - Internal Properties

	let id = UUID()
	let decimals: Int
	var walletType: WalletType
	var address: String
	var coinAmount: String
	var fiatAmount: String

	var result: (image: Image, fiatAmount: String, currency: String) {
		switch walletType {
		case .ethereum:
			return (R.image.wallet.ethereumCard.image,
                    fiatAmount,
					currency: "ETH")
		case .aur:
			return (R.image.wallet.card.image,
                    fiatAmount,
					currency: "AUR")
		case .bitcoin:
			return (R.image.wallet.ethereumCard.image,
                    fiatAmount,
					currency: "BTC")
        case .binance:
            return (R.image.wallet.ethereumCard.image,
                    fiatAmount,
                    currency: "BNC")
		}
	}
}
