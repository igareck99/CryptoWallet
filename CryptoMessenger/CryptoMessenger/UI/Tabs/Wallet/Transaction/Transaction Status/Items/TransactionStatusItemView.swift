import SwiftUI

struct TransactionStatusItemView: View {
    let model: TransactionStatusItem

    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            Text(model.leadingText)
                .font(.bodyRegular17)
                .foregroundColor(model.leadingTextColor)
            Spacer()
            Text(model.trailingText)
                .font(.bodyRegular17)
                .foregroundColor(model.leadingTextColor)
                .truncationMode(.middle)
        }
        .frame(height: 54)
    }
}
