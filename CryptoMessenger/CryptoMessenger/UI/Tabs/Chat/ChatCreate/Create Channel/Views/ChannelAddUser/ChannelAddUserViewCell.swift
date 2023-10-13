import SwiftUI

// MARK: - ChannelAddUserViewCell

struct ChannelAddUserViewCell: View {

    // MARK: - Internal Properties

    let avatar: URL?
    let name: String
    var onInvite: VoidBlock?

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                AsyncImage(
                    defaultUrl: avatar,
                    placeholder: {
                        ZStack {
                            Color.aliceBlue
                            Text(name.firstLetter.uppercased())
                                .font(.title2Bold22)
                                .foregroundColor(.white)
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 40, height: 40)
                .cornerRadius(20)

                Text(name)
                    .font(.title2Regular22)
                    .foregroundColor(.chineseBlack)
                    .padding(.top, 12)
            }
            .padding(.horizontal, 16)
        }
    }
}
