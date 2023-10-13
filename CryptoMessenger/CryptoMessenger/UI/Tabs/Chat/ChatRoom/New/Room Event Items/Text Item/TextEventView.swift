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
                        .padding(.top, 8)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(model.userId)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.dodgerBlue)
                        .padding(.top, 8)
                        Text(model.replyDescription)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.chineseBlack)
                    }
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: 289)
                .frame(height: 39)
            }
            Text(model.text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.chineseBlack)
                .padding(.top, model.isReply ? 13 : 0)
            VStack(spacing: 2) {
                HStack {
                    reactions
                    Spacer()
                }
                eventData
            }
        }
        .onAppear {
            print("slaslasl  \(model.width)")
        }
        .padding(.leading, 4)
        .frame(width: model.width)
    }
}
