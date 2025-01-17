import SwiftUI

// swiftlint:disable all

// MARK: - WalletCardView

struct WalletCardView: View {

	// MARK: - Internal Properties

	let wallet: WalletInfo

	// MARK: - Body

	var body: some View {
		switch wallet.walletType {
		case .aur:
			VStack(alignment: .leading) {
				wallet.result.image.resizable()
			}
		case .ethereum, .bitcoin:

			VStack(alignment: .leading) {
				HStack(alignment: .top) {
					VStack(alignment: .leading, spacing: 4) {
						Text(String(wallet.coinAmount) + " \(wallet.result.currency)")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
						Text(String(wallet.result.fiatAmount) + " USD")
                            .font(.system(size: 15))
                            .foregroundColor(.white06)
					}
					Spacer()
				}
                .padding([.top, .leading], 16)
                
				Spacer()
				
                HStack {
					Spacer()
					Text(wallet.address)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
						.lineLimit(1)
						.truncationMode(.middle)
						.frame(width: 150)
						.padding(.trailing, 24)
				}
				.padding(.bottom, 19)
			}
			.background(
				Image(
					wallet.walletType == .bitcoin ?
					R.image.wallet.bitcoinCard.name :
						R.image.wallet.ethereumCard.name
					 )
				.resizable()
				.frame(width: 343, height: 180)
			)
		}
	}
}

// MARK: - RewardsView

struct SlideCardsView: View {

	// MARK: - Internal Properties

	let cards: [WalletInfo]
	var onOffsetChanged: (CGFloat) -> Void
	var onAddressSend: (Int, String) -> Void

	// MARK: - Private Properties

	private let spacing = CGFloat(8)

	// MARK: - Body

	var body: some View {
		TrackableScrollView(axes: .horizontal, offsetChanged: { offset in
			onOffsetChanged(offset)
		}, content: {
			HStack(spacing: spacing) {
				ForEach(cards) { wallet in
                    WalletCardView(wallet: wallet)
						.onTapGesture {
							switch wallet.walletType {
							case .ethereum:
								onAddressSend(0, wallet.address)
							case .bitcoin:
								onAddressSend(1, wallet.address)
							default:
								break
							}
						}
						.frame(width: 343, height: 193)
						.padding([.leading, .trailing], 16)
				}
			}
		}).frame(height: 193)
	}
}
