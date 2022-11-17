import SwiftUI

// MARK: - ReactionsSelectView

struct ReactionsSelectView: View {

    // MARK: Internal Properties

    @Binding var cardPosition: CardPosition
    let onReaction: GenericBlock<String>
    var emotions = ["👍", "👎", "😘", "😢", "😱"]

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 11) {
                ForEach(emotions, id: \.self) { item in
                    ZStack {
                        Circle()
                            .frame(width: 40,
                                   height: 40)
                            .foreground(.blue(0.1))
                        Text(item)
                            .frame(width: 24,
                                   height: 33)
                    }
                    .onTapGesture {
                        vibrate()
                        onReaction(item)
                        cardPosition = .bottom
                    }
                }
                ZStack {
                    Circle()
                        .frame(width: 40,
                               height: 40)
                        .foreground(.blue(0.1))
                    R.image.chat.reaction.pickEmoji.image
                        .frame(width: 22,
                               height: 22)
                }
            }
        }
    }
}
