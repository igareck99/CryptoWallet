import SwiftUI

// MARK: - TransactionDetailsView

struct TransactionDetailsView: View {

    // MARK: - Internal Properties

    let model: TransactionDetails

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text("Отправитель")
                    .font(.system(size: 13))
                Spacer()
                Text(model.sender)
                    .foregroundColor(.romanSilver)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.system(size: 15))
            }
            .frame(height: 32)

            HStack(alignment: .center, spacing: 0) {
                Text("Получатель")
                    .font(.system(size: 13))
                Spacer()
                Text(model.receiver)
                    .foregroundColor(.romanSilver)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.system(size: 15))
            }
            .frame(height: 32)

            HStack(alignment: .center, spacing: 0) {
                Text("Блок")
                    .font(.system(size: 13))
                Spacer()
                Text(model.block)
                    .foregroundColor(.romanSilver)
                    .font(.system(size: 15))
            }
            .frame(height: 32)

            HStack(alignment: .center, spacing: 0) {
                Text("Хэш")
                    .font(.system(size: 13))
                Spacer()
                Text(model.hash)
                    .foregroundColor(.romanSilver)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.system(size: 15))
            }
            .frame(height: 32)
            .padding(.bottom, 8)
        }
    }
}
