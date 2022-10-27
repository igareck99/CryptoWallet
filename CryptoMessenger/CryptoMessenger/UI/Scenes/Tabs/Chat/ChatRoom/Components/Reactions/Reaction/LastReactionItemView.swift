import SwiftUI

// MARK: - LastReactionItemView

struct LastReactionItemView: View {

    // MARK: - Internal Properties

    let emoji: String
    let isLastButton: Bool

    // MARK: - Body

    var body: some View {
        HStack {
            if !isLastButton {
                Text(emoji)
                    .font(.regular(22))
            } else {
                R.image.chat.reaction.pickEmoji.image
            }
        }
        .frame(width: 40, height: 40, alignment: .center)
        .background(.blue(0.1))
        .cornerRadius(20)
    }
}
