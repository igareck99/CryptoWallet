import SwiftUI

// MARK: - ReplyView

struct ReplyView: View {

    // MARK: - Internal Properties

    let text: String
    let viewType: ReplyEditViewState
    let onReset: VoidBlock

    // MARK: - Body

    var body: some View {
        VStack(spacing: .zero) {
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gainsboro)
            Spacer()
            HStack(spacing: 0) {
                viewType.image
                    .padding(.leading, 8)

                VStack(alignment: .leading, spacing: 0) {
                    Text(viewType.text)
                        .font(.caption1Regular12)
                        .foregroundColor(.dodgerBlue)

                    Text(text)
                        .font(.subheadlineRegular15)
                        .foregroundColor(.chineseBlack)
                }
                .padding(.leading, 16)
                Spacer()
                Button(action: onReset, label: {
                    R.image.chat.reply.cancelReply.image
                        .padding(.trailing, 10)
                })
            }
            Spacer()
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gainsboro)
        }
        .frame(height: 50)
        .background(.white)
    }
}

enum ReplyEditViewState {
    case reply
    case edit

    var text: String {
        switch self {
        case .reply:
            return R.string.localizable.replyViewReply()
        case .edit:
            return R.string.localizable.editViewEdit()
        }
    }

    var image: Image {
        switch self {
        case .reply:
            return R.image.chat.reply.reply.image
        case .edit:
            return R.image.chat.reply.edit.image
        }
    }
}
