import SwiftUI

// MARK: - ChannelParticipantView

struct ChannelParticipantView: View {
    
    // MARK: - Internal Properties
    
    let avatar: URL?
    let title: String
    let subtitle: String

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            avatarView
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodyRegular17)
                    .foregroundColor(.chineseBlack)
                Text(subtitle)
                    .font(.caption1Regular12)
                    .foregroundColor(.romanSilver)
            }
        }
    }
    
    private var avatarView: some View {
        AsyncImage(defaultUrl: avatar,
                   updatingPhoto: false,
                   url: nil,
                   placeholder: {
            ZStack {
                Circle()
                    .cornerRadius(20)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.diamond)
                Text(title.firstLetter.uppercased())
                    .foregroundColor(.white)
                    .font(.title1Bold28)
                    .frame(width: 20,
                           height: 20)
            }
        },
                   result: {
            Image(uiImage: $0)
                .resizable()
        })
    }
}
