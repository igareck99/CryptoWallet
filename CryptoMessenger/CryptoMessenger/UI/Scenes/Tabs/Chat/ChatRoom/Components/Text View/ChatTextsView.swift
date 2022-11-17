import SwiftUI

// MARK: - ChatTextsView

struct ChatTextsView: View {

    // MARK: - Private Properties

    private let isFromCurrentUser: Bool
    private let shortDate: String
    private let text: String
    private let isReply: Bool
    private let imageName: String
    private let reactionItem: [ReactionTextsItem]

    // MARK: - Lifecycle

    init(
        isFromCurrentUser: Bool,
        shortDate: String,
        text: String,
        isReply: Bool,
        reactionItem: [ReactionTextsItem],
        imageName: String = R.image.chat.readCheck.name
    ) {
        self.isFromCurrentUser = isFromCurrentUser
        self.shortDate = shortDate
        self.text = text
        self.isReply = isReply
        self.reactionItem = reactionItem
        self.imageName = imageName
    }

    // MARK: - Body

    var body: some View {
        reactionsView
    }

    private var reactionsView: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(text)
                    .lineLimit(nil)
                    .font(.regular(15))
                    .foreground(.black())
                    .padding(.top, 8)
                    .padding(.bottom, reactionItem.isEmpty ? 8 : 0)
                    .fixedSize(horizontal: false, vertical: true)
                if !reactionItem.isEmpty {
                    ReactionsGroupView(viewModel: ReactionsGroupViewModel(items: reactionItem))
                        .frame(minHeight: 28)
                        .padding(.top, 4)
                        .padding(.bottom, 2)
                }

                HStack(spacing: 0) {
                    if isReply {
                        Spacer()
                    }
                    Color.clear.frame(height: 0)
                    Text(shortDate)
                        .frame(width: 40, height: 10)
                        .font(.light(12))
                        .foreground(.black(0.5))
                        .fixedSize()

                    if isFromCurrentUser {
                        Image(imageName)
                            .resizable()
                            .frame(width: 13.5, height: 10, alignment: .center)
                    }
                }
                .padding(.leading, isReply ? CGFloat(reactionItem.count) * 52 : 24)
                .padding(.bottom, 8)
            }
            .padding(.leading, isFromCurrentUser ? 8 : 16)
            .padding(.trailing, isFromCurrentUser ? 16 : 8)
        }
        .scaledToFit()
    }
}
