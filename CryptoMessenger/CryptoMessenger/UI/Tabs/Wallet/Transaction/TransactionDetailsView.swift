import SwiftUI

// MARK: - TransactionDetailsView

struct TransactionDetailsView: View {

    // MARK: - Internal Properties

    let model: TransactionDetails

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(R.string.localizable.transactionSender())
                    .font(.footnoteRegular13)
                Spacer()
                Text(model.sender)
                    .foregroundColor(.romanSilver)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.subheadlineRegular15)
            }
            .frame(height: 32)

            HStack(alignment: .center, spacing: 0) {
                Text(R.string.localizable.transactionReciver())
                    .font(.footnoteRegular13)
                Spacer()
                Text(model.receiver)
                    .foregroundColor(.romanSilver)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.subheadlineRegular15)
            }
            .frame(height: 32)

            HStack(alignment: .center, spacing: 0) {
                Text(R.string.localizable.transactionBlock())
                    .font(.footnoteRegular13)
                Spacer()
                Text(model.block)
                    .foregroundColor(.romanSilver)
                    .font(.subheadlineRegular15)
            }
            .frame(height: 32)

            HStack(alignment: .center, spacing: 0) {
                Text(R.string.localizable.transactionHash())
                    .font(.footnoteRegular13)
                Spacer()
                Text(model.hash)
                    .foregroundColor(.romanSilver)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.subheadlineRegular15)
            }
            .frame(height: 32)
            .padding(.bottom, 8)
        }
    }
}
