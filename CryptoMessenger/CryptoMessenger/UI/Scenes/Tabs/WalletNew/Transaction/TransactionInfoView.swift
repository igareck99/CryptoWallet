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
						transaction.type == .send ?
						R.image.wallet.writeOff.image :
						R.image.wallet.inflow.image
					}
					VStack(alignment: .leading, spacing: 6) {
						Text(transaction.transactionResult)
						.font(.medium(15))
						Text(
							(transaction.date.utcToLocal ?? "")
							+ " From: " +
							transaction.from
						)
						.lineLimit(1)
						.truncationMode(.tail)
						.font(.regular(13))
						.foreground(.darkGray())
					}
				}
				Spacer()
				VStack(alignment: .trailing) {
					switch transaction.transactionCoin {
					case .aur:
						Text("+ \(transaction.amount) AUR")
						.font(.regular(15))
						.foreground(transaction.type == .send ? .black() : .green())
						.lineLimit(1)
						.truncationMode(.middle)
					case .ethereum:
						Text("+ \(transaction.amount) ETH")
						.font(.regular(15))
						.foreground(transaction.type == .send ? .black() : .green())
						.lineLimit(1)
						.truncationMode(.middle)
					case .bitcoin:
						Text("+ \(transaction.amount) BTC")
						.font(.regular(15))
						.foreground(transaction.type == .send ? .black() : .green())
						.lineLimit(1)
						.truncationMode(.middle)
					}
				}
			}
			Divider()
		}
	}
}
