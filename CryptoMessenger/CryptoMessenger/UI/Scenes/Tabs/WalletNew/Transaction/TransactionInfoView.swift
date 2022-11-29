import SwiftUI

// MARK: - TransactionInfoView

struct TransactionInfoView: View {

	// MARK: - Internal Properties

	var transaction: TransactionInfo

	// MARK: - Body

	var body: some View {
		VStack(spacing: 16) {
			HStack {
				HStack(spacing: 12) {
					ZStack {
						Circle()
							.frame(width: 40, height: 40)
							.foreground(transaction.type == .send ? .blue() : .green())
						transaction.type == .send ? R.image.wallet.writeOff.image :
						R.image.wallet.inflow.image
					}
					VStack(alignment: .leading, spacing: 6) {
						Text(transaction.type == .send ? R.string.localizable.walletShipped() :
								R.string.localizable.walletReceived())
						.font(.medium(15))
						Text(transaction.date + " " + "From:" + transaction.from)
							.font(.regular(13))
							.foreground(.darkGray())
					}
				}
				Spacer()
				VStack(alignment: .trailing) {
					switch transaction.transactionCoin {
					case .aur:
						Text(transaction.amount > 0 ? String("+ \(transaction.amount)") + " AUR":
								String("- \(abs(transaction.amount))") + " AUR")
						.font(.regular(15))
						.foreground(transaction.type == .send ? .black(): .green())
					case .ethereum:
						Text(transaction.amount > 0 ? String("+ \(transaction.amount)") + " ETH":
								String("- \(abs(transaction.amount))") + " ETH")
						.font(.regular(15))
						.foreground(transaction.type == .send ? .black(): .green())
					case .bitcoin:
						Text(transaction.amount > 0 ? String("+ \(transaction.amount)") + " BTC":
								String("- \(abs(transaction.amount))") + " BTC")
						.font(.regular(15))
						.foreground(transaction.type == .send ? .black(): .green())
					}
					Text(String(transaction.amount) + " USD")
						.font(.regular(13))
						.foreground(.darkGray())
				}
			}
			Divider()
		}
	}
}
