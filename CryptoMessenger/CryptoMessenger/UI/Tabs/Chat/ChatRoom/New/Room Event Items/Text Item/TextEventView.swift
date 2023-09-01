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
            Text(model.text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.chineseBlack)
            VStack(spacing: 2) {
                reactions
                eventData
            }
        }
        .frame(width: model.width)
    }
}
