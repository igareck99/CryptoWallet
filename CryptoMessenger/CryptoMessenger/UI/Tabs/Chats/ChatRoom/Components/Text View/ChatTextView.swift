import SwiftUI

// MARK: - ChatTextView

struct ChatTextView: View {

    // MARK: - Private Properties

    private let message: RoomMessage
    private let isFromCurrentUser: Bool
    private let shortDate: String
    private let text: String
    private let isReply: Bool
    private let imageName: String
    private let reactionItem: [ReactionTextsItem]

    // MARK: - Lifecycle

    init(
        message: RoomMessage,
        isFromCurrentUser: Bool,
        shortDate: String,
        text: String,
        isReply: Bool,
        reactionItem: [ReactionTextsItem],
        imageName: String = R.image.chat.readCheck.name
    ) {
        self.message = message
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
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                if message.isReply {
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 1)
                            .frame(width: 2)
                            .foregroundColor(.dodgerBlue)
                            .padding(.top, 8)
                            .padding(.leading, 16)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(message.name,
                                 [
                                    .paragraph(.init(lineHeightMultiple: 1.19, alignment: .left))
                                 ]
                            )
                            .font(.footnoteSemibold13)
                            .foregroundColor(.chineseBlack)
                            .padding(.top, 8)
                            Text(message.replyDescription,
                                 [
                                    .paragraph(.init(lineHeightMultiple: 1.2,
                                                     alignment: .left))
                                 ]
                            ) .font(.footnoteRegular13)
                                .foregroundColor(.chineseBlack)
                        }
                        .frame(minWidth: 0, maxWidth: 70)
                        .padding(.leading, 8)
                        .padding(.trailing, 16)
                    }
                    .frame(height: 40)
                }
                Text(text)
                    .lineLimit(nil)
                    .font(.bodyRegular17)
                    .foregroundColor(.chineseBlack)
                    .padding(.top, 8)
                    .padding(.bottom, reactionItem.isEmpty ? 8 : 0)
                    .padding(.leading, 12)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(minWidth: 0,
                           maxWidth: 249,
                           alignment: .leading)
                if !reactionItem.isEmpty {
                    ReactionsGroupView(viewModel: ReactionsGroupViewModel(items: reactionItem))
                        .frame(minHeight: 28)
                        .padding(.top, 4)
                        .padding(.bottom, 2)
                }

                HStack(spacing: 0) {
                    Spacer()
                    Text(shortDate)
                        .frame(width: 40, height: 10)
                        .font(.caption1Regular12)
                        .foregroundColor(.chineseBlack04)
                        .fixedSize()
                    if isFromCurrentUser {
                        Image(imageName)
                            .resizable()
                            .frame(width: 13.5, height: 10, alignment: .center)
                    }
                }
                .padding(.leading, computePadding())
                .padding(.bottom, 8)
            }
            .padding(.leading, isFromCurrentUser ? 8 : 16)
            .padding(.trailing, isFromCurrentUser ? 16 : 8)
        }
        .frame(minWidth: 0,
               maxWidth: 300,
               alignment: .leading)
        .scaledToFit()
    }

    // TODO: - Перессчитать
    private func computePadding() -> CGFloat {
        var computeValue = CGFloat(Double(text.count % 26) * 7)
        var constantValue = CGFloat(Double(26) * 6.9)
            if text.count < 26 {
                return computeValue
            }
            return CGFloat(Double(26) * 6.9)
    }
}
