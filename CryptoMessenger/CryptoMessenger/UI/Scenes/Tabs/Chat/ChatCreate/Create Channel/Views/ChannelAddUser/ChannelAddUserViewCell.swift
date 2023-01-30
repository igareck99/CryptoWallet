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
                    url: avatar,
                    placeholder: {
                        ZStack {
                            Color(.lightBlue())
                            Text(name.firstLetter.uppercased())
                                .foreground(.white())
                                .font(.medium(22))
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
                    .font(.semibold(15))
                    .foreground(.black())
                    .padding(.top, 12)
            }
            .padding(.horizontal, 16)
        }
    }
}
