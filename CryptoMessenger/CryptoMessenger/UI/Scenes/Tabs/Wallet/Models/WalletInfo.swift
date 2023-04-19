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
    var tokenAddress: String?
	var coinAmount: String
	var fiatAmount: String

    struct WalletInfoData {
        let image: Image
        let fiatAmount: String
        let currency: String
        let networkTitle: String
    }

	var result: WalletInfoData {
		switch walletType {
        case .ethereum:
            return .init(
                image: R.image.wallet.ethereumCard.image,
                fiatAmount: fiatAmount,
                currency: walletType.currency,
                networkTitle: walletType.networkTitle
            )
		case .aur:
            return .init(
                image: R.image.wallet.auraCard.image,
                fiatAmount: fiatAmount,
                currency: walletType.currency,
                networkTitle: walletType.networkTitle
            )
		case .bitcoin:
            return .init(
                image: R.image.wallet.bitcoinCard.image,
                fiatAmount: fiatAmount,
                currency: walletType.currency,
                networkTitle: walletType.networkTitle
            )
        case .binance:
            return .init(
                image: R.image.wallet.binanceCard.image,
                fiatAmount: fiatAmount,
                currency: walletType.currency,
                networkTitle: walletType.networkTitle
            )
        case .binanceUSDT, .binanceBUSD,
                .ethereumUSDT, .ethereumUSDC:
            return .init(
                image: R.image.wallet.auraCard.image,
                fiatAmount: fiatAmount,
                currency: walletType.currency,
                networkTitle: walletType.networkTitle
            )
		}
	}
}
