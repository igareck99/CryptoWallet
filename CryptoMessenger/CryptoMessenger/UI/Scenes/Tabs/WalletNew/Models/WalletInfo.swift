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
	var walletType: WalletType
	var address: String
	var coinAmount: String
	var fiatAmount: String

	var result: (image: Image, fiatAmount: String, currency: String) {
		switch walletType {
		case .ethereum:
			return (R.image.wallet.ethereumCard.image,
					coinAmount,
					currency: "ETH")
		case .aur:
			return (R.image.wallet.card.image,
					coinAmount,
					currency: "AUR")
		case .bitcoin:
			return (R.image.wallet.ethereumCard.image,
					coinAmount,
					currency: "BTC")
		}
	}
}
