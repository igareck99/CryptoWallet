import SwiftUI

// MARK: - ReactionsSelectView

struct ReactionsSelectView: View {

    // MARK: Internal Properties

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
                            .foregroundColor(.dodgerTransBlue)
                        Text(item)
                            .frame(width: 24,
                                   height: 33)
                    }
                    .onTapGesture {
                        vibrate()
                        onReaction(item)
                    }
                }
                ZStack {
                    Circle()
                        .frame(width: 40,
                               height: 40)
                        .foregroundColor(.dodgerTransBlue)
                    R.image.chat.reaction.pickEmoji.image
                        .frame(width: 22,
                               height: 22)
                }
            }
        }
    }
}
