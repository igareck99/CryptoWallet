import SwiftUI

// MARK: - TransactionInfoView

struct TransactionInfoView: View {

	// MARK: - Internal Properties

	var transaction: TransactionInfo

	// MARK: - Body

	var body: some View {
		VStack(spacing: 16) {
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
						HStack {
							Text(transaction.transactionResult)
								.font(.system(size: 17))
								.foregroundColor(.woodSmokeApprox)
							Spacer()
							transactionAmount()
						}

						Text(
							(transaction.date.utcToLocal ?? "")
							+ " From: " +
							transaction.from
						)
						.lineLimit(1)
						.truncationMode(.tail)
						.font(.system(size: 12))
						.foregroundColor(.regentGrayApprox)
					}
				}
			Divider()
		}
	}

	@ViewBuilder
	private func transactionAmount() -> some View {
		switch transaction.transactionCoin {
		case .aur:
			Text("+ \(transaction.amount) AUR")
				.font(.system(size: 17))
				.foreground(transaction.type == .send ? .black() : .green())
				.lineLimit(1)
				.truncationMode(.middle)
		case .ethereum:
			Text("+ \(transaction.amount) ETH")
				.font(.system(size: 17))
				.foreground(transaction.type == .send ? .black() : .green())
				.lineLimit(1)
				.truncationMode(.middle)
		case .bitcoin:
			Text("+ \(transaction.amount) BTC")
				.font(.system(size: 17))
				.foreground(transaction.type == .send ? .black() : .green())
				.lineLimit(1)
				.truncationMode(.middle)
		}
	}
}
