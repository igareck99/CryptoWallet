import SwiftUI

struct TransactionEventView<
    EventData: View,
    Reactions: View
>: View {
    let model: TransactionEvent
    let eventData: EventData
    let reactions: Reactions

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(model.title)
                .font(.system(size: 16))
                .foregroundColor(.chineseBlack)
            Text(model.subtitle)
                .font(.system(size: 13))
                .foregroundColor(.dodgerBlue)
            RoundedRectangle(cornerRadius: 4)
                .fill(model.amountBackColor)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                .overlay {
                    Text(model.amount)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.chineseBlack)
                }
                .onTapGesture {
                    model.onTap()
                }
            reactions
            eventData
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}
