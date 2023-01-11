import SwiftUI

struct TransactionDetailsView: View {

	let model: TransactionDetails

    var body: some View {
		VStack(alignment: .center, spacing: 4) {
			HStack(alignment: .center, spacing: 0) {
				Text("Отправитель")
					.font(.system(size: 13))
				Spacer()
				Text(model.sender)
					.lineLimit(1)
					.truncationMode(.middle)
					.font(.system(size: 15))
			}
			HStack(alignment: .center, spacing: 0) {
				Text("Получатель")
					.font(.system(size: 13))
				Spacer()
				Text(model.receiver)
					.lineLimit(1)
					.truncationMode(.middle)
					.font(.system(size: 15))
			}
			HStack(alignment: .center, spacing: 0) {
				Text("Блок")
					.font(.system(size: 13))
				Spacer()
				Text(model.block)
					.font(.system(size: 15))
			}
			HStack(alignment: .center, spacing: 0) {
				Text("Хэш")
					.font(.system(size: 13))
				Spacer()
				Text(model.hash)
					.lineLimit(1)
					.truncationMode(.middle)
					.font(.system(size: 15))
			}
		}
		.background(Color.alabasterSolid)
    }
}
