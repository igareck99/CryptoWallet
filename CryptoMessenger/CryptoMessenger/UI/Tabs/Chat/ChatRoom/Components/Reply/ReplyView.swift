import SwiftUI

// MARK: - ReplyView

struct ReplyView: View {

    // MARK: - Internal Properties

    let text: String
    let onReset: VoidBlock

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                R.image.chat.reply.reply.image
                    .padding(.leading, 8)

                VStack(alignment: .leading, spacing: 0) {
                    Text(R.string.localizable.replyViewReply(), [
                        .paragraph(.init(lineHeightMultiple: 1.12, alignment: .left))
                    ]).font(.system(size: 12, weight: .regular))
                        .foregroundColor(.dodgerBlue)
                        .frame(height: 13)

                    Text(text, [
                        .paragraph(.init(lineHeightMultiple: 1.09, alignment: .left))
                    ]).font(.system(size: 15, weight: .regular))
                        .foregroundColor(.chineseBlack)
                        .frame(height: 20)
                        .padding(.top, 3)
                }
                .padding(.leading, 20)
                .padding(.trailing, 24)

                Spacer()

                Button(action: onReset, label: {
                    R.image.chat.reply.close.image
                        .padding(.trailing, 8)
                })
            }
            .padding(.bottom, 1)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.ashGray)
        }
        .frame(height: 54)
        .background(.white)
    }
}

struct EditView: View {

    // MARK: - Internal Properties

    let text: String
    let onReset: VoidBlock

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                R.image.chat.reaction.edit.image
                    .padding(.leading, 16)

                VStack(alignment: .leading, spacing: 0) {
                    Text(R.string.localizable.editViewEdit(), [
                        .paragraph(.init(lineHeightMultiple: 1.12, alignment: .left))
                    ]).font(.system(size: 12, weight: .regular))
                        .foregroundColor(.dodgerBlue)
                        .frame(height: 13)

                    Text(text, [
                        .paragraph(.init(lineHeightMultiple: 1.09, alignment: .left))
                    ]).font(.system(size: 15, weight: .regular))
                        .foregroundColor(.chineseBlack)
                        .frame(height: 20)
                        .padding(.top, 3)
                }
                .padding(.leading, 20)
                .padding(.trailing, 24)

                Spacer()

                Button(action: onReset, label: {
                    R.image.chat.reply.close.image
                        .padding(.trailing, 8)
                })
            }
            .padding(.bottom, 1)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.romanSilver)
        }
        .frame(height: 54)
        .background(.white)
    }
}
