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
		}
	}

	@ViewBuilder
	private func transactionAmount() -> some View {
        Text("\(transaction.sign) \(transaction.amount) \(transaction.transactionCoin.abbreviatedName)")
            .font(.system(size: 17))
            .foregroundColor(
                transaction.type == .send ?
                    .woodSmokeApprox : .jungleGreenApprox
            )
            .lineLimit(1)
            .truncationMode(.middle)
	}
}
