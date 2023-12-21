import SwiftUI

// MARK: - ReactionsSelectView

struct ReactionsSelectView: View {

    // MARK: Internal Properties

    let onReaction: GenericBlock<String>
    var emotions = ["👍", "👎", "😘", "😢", "😱"]

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .center) {
                HStack(spacing: 8) {
                    ForEach(emotions, id: \.self) { item in
                        ZStack {
                            Circle()
                                .frame(width: 36,
                                       height: 36)
                                .foregroundColor(.aliceBlue)
                            Text(item)
                                .font(.regular(24))
                        }
                        .onTapGesture {
                            vibrate()
                            onReaction(item)
                        }
                    }
                }
            }.frame(height: 55)
        }
    }
}
