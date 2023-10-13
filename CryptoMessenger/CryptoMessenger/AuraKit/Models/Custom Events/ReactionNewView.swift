import SwiftUI

// MARK: - ReactionNewView

struct ReactionNewView: View {
    
    // MARK: - Internal Properties

    let value: ReactionNewEvent

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .contentShape(Rectangle())
                .foregroundColor(value.color)
                .cornerRadius(30)
            HStack(spacing: 4) {
                Text(value.emoji)
                    .font(.title3Regular20)
                if value.emojiCount != 1 || value.emojiString.contains("+") {
                    Text(value.emojiString)
                        .font(.caption2Semibold11)
                        .foregroundColor(value.textColor)
                }
            }
        }
        .frame(width: value.width, height: 28)
        .onTapGesture {
            value.onTap(value)
        }
    }
}
