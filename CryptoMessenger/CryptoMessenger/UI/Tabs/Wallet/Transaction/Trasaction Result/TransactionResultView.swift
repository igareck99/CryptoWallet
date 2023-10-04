import SwiftUI

// MARK: - TransactionResultView

struct TransactionResultView: View {
    
    // MARK: - Internal Properties

	let model: TransactionResult
    let height: CGFloat

    // MARK: - Private Properties

	@Environment(\.presentationMode) private var presentationMode
    
    // MARK: - Body

	var body: some View {
		VStack(spacing: 0) {
			RoundedRectangle(cornerRadius: 2)
				.frame(width: 31, height: 4)
				.foregroundColor(.chineseBlack04)
				.padding(.top, 5)
				.padding(.bottom, 16)

			Text(model.title)
				.font(.bodySemibold17)
				.foregroundColor(.chineseBlack)

			Image(model.resultImageName)
				.resizable()
				.frame(width: 48, height: 48, alignment: .center)
				.padding(.top, 27)

			Text(model.amount)
				.lineLimit(1)
				.truncationMode(.middle)
				.frame(alignment: .center)
				.font(.largeTitleRegular34)
				.foregroundColor(.chineseBlack)
				.padding(.top, 8)

			Text(model.receiverName)
				.lineLimit(1)
				.truncationMode(.middle)
				.frame(alignment: .center)
				.font(.title2Regular22)
				.foregroundColor(.chineseBlack)
				.padding(.top, 22)

			Text(model.receiversWallet)
				.lineLimit(1)
				.truncationMode(.middle)
				.frame(alignment: .center)
				.font(.subheadlineRegular15)
				.foregroundColor(.romanSilver)
				.padding(.top, 4)
				.padding(.horizontal, 32)
			Spacer()
		}
        .presentationDetents([.height(height)])
	}
}
