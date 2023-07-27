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
                    .font(.system(size: 22, weight: .regular))
            } else {
                R.image.chat.reaction.pickEmoji.image
            }
        }
        .frame(width: 40, height: 40, alignment: .center)
        .background(Color.dodgerTransBlue)
        .cornerRadius(20)
    }
}
