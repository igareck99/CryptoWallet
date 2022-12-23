import SwiftUI

struct TransactionResultView: View {

	let model: TransactionResult

    var body: some View {

		VStack(spacing: 0) {
			Text(model.title)
				.font(.system(size: 17, weight: .semibold))
				.foregroundColor(.woodSmokeApprox)

			Image(model.resultImageName)
				.resizable()
				.frame(width: 48, height: 48, alignment: .center)
				.padding(.top, 27)

			Text(model.amount)
				.lineLimit(1)
				.truncationMode(.middle)
				.frame(alignment: .center)
				.font(.system(size: 34))
				.foregroundColor(.woodSmokeApprox)
				.padding(.top, 8)

			Text(model.receiverName)
				.lineLimit(1)
				.truncationMode(.middle)
				.frame(alignment: .center)
				.font(.system(size: 22))
				.foregroundColor(.woodSmokeApprox)
				.padding(.top, 22)

			Text(model.receiversWallet)
				.lineLimit(1)
				.truncationMode(.middle)
				.frame(alignment: .center)
				.font(.system(size: 15))
				.foregroundColor(.regentGrayApprox)
				.padding(.top, 4)
				.padding(.horizontal, 32)
		}
    }
}
