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
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: 2)
                        .foregroundColor(.dodgerBlue)
                        .padding(.top, 8)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("",
                             [
                                .paragraph(.init(lineHeightMultiple: 1.19, alignment: .left))
                             ]
                        )
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.chineseBlack)
                        .padding(.top, 8)
                        Text(model.replyDescription,
                             [
                                .paragraph(.init(lineHeightMultiple: 1.2,
                                                 alignment: .left))
                             ]
                        ) .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.chineseBlack)
                    }
                    .frame(minWidth: 0, maxWidth: 70)
                }
                .frame(height: 40)
            }
            Text(model.text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.chineseBlack)
            VStack(spacing: 2) {
                HStack {
                    reactions
                    Spacer()
                }
                eventData
            }
        }
        .padding(.leading, 4)
        .frame(width: model.width)
    }
}
