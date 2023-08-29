import SwiftUI

struct TextEventView<
    EventData: View,
    Reactions: View
>: View {
    let model: TextEvent
    let eventData: EventData
    let reactions: Reactions

    var body: some View {
        VStack(spacing: .zero) {
            Text(model.text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.chineseBlack)

            reactions

            eventData
        }
        .frame(width: calculateWidth())
    }

    private func calculateWidth() -> CGFloat {
        let textWidth = model.text.width(font: .systemFont(ofSize: 17)) + 8
        let maxWidth = UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.3 
        return textWidth < maxWidth ? textWidth : maxWidth
    }
}
