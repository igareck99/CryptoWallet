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
                .font(.bodyRegular17)
                .foregroundColor(.chineseBlack)
            Text(model.subtitle)
                .font(.footnoteRegular13)
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
                        .font(.title2Regular22)
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
