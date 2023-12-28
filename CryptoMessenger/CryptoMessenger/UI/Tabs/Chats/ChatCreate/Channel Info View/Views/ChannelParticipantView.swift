import SwiftUI

// MARK: - ChannelParticipantView

struct ChannelParticipantView: View {
    
    // MARK: - Internal Properties
    
    let title: String
    let subtitle: String

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Circle()
                .foregroundColor(.diamond)
                .frame(width: 40, height: 40)
                .cornerRadius(20)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodyRegular17)
                    .foregroundColor(.chineseBlack)
                Text(subtitle)
                    .font(.caption1Regular12)
                    .foregroundColor(.romanSilver)
                    .padding(.top, 4)
            }
        }.frame(height: 64)
    }
}
