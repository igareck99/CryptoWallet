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
                .onTapGesture {
                }
                .foregroundColor(value.color)
                .frame(height: 28)
                .frame(width: value.width)
                .cornerRadius(30)
            HStack(spacing: 4) {
                Text(value.emoji)
                    .font(.regular(20))
                if value.emojiCount != 1 {
                    Text(String(value.emojiCount))
                        .font(.semibold(13))
                        .foregroundColor(value.textColor)
                }
            }
        }
        .onTapGesture {
            print("skasklasklasklasklas  \(value)")
            value.onTap(value)
        }
    }
}
