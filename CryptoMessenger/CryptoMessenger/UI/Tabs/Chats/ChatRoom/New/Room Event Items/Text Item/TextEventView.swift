import SwiftUI

// MARK: - TextEventView

struct TextEventView<
    EventData: View,
    Reactions: View
>: View {
    let model: TextEvent
    let eventData: EventData
    let reactions: Reactions

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if model.isReply {
                HStack(spacing: 8) {
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(.dodgerBlue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(model.userId)
                        .font(.bodyRegular17)
                        .foregroundColor(.dodgerBlue)
                        Text(model.replyDescription)
                            .foregroundColor(.chineseBlack)
                    }
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: 289, idealHeight: 39)
            }
            Text(model.text)
                .font(.bodyRegular17)
                .foregroundColor(.chineseBlack)
                .padding(.top, model.isReply ? 6 : 0)
            VStack(spacing: 2) {
                HStack {
                    reactions
                    Spacer()
                }
                eventData
            }
            .padding(.top, 2)
        }
        .padding(.leading, 4)
        .frame(width: model.width)
    }
}
