import SwiftUI

// MARK: - CardNewView

struct CardNewView: View {

    // MARK: - Internal Properties

    let wallet: WalletInfo
    let image = UIImage(systemName: "exclamationmark.circle")?.tintColor(.white())

    // MARK: - Body

    var body: some View {
        switch wallet.walletType {
        case .aur:
            VStack(alignment: .leading) {
                wallet.result.image.resizable()
            }
        case .ethereum, .bitcoin:
            ZStack {
                wallet.result.image.resizable()

                VStack(alignment: .leading) {
                    HStack(alignment: .top ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(String(wallet.coinAmount) + " \(wallet.result.currency)")
                                .font(.regular(22))
                                .foreground(.white())
                            Text(String(wallet.result.fiatAmount) + " USD")
                                .font(.regular(12))
                                .foreground(.white(0.4))
                        }
                        .padding(.leading, 20)
                        Spacer()
                        Button {
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 36, height: 36)
                                    .foreground(.gray335664())
                                R.image.wallet.plus.image
                            }
                        }
                        .padding(.trailing, 14)
                    }
                    .padding(.top, 20)
                    Spacer()
                    HStack {
                        Text("")
                            .padding(.leading, 20)
                        Spacer()
                        HStack(spacing: 10) {
                            Text(wallet.address)
                                .font(.regular(16))
                                .foreground(.white())
								.truncationMode(.middle)
                            Image(uiImage: image ?? UIImage())
                                .frame(width: 30, height: 30)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.bottom, 19)
                }
            }
//        case .bitcoin:
//            VStack(alignment: .leading) {
//                wallet.result.image.resizable()
//            }
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
					CardNewView(wallet: wallet)
						.onTapGesture {
							switch wallet.walletType {
							case .ethereum:
								onAddressSend(0, wallet.address)
							case .aur:
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
