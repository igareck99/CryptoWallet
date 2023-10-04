import SwiftUI

// MARK: - ChannelParticipantView

struct ChannelParticipantView: View {
    
    // MARK: - Internal Properties
    
    let title: String
    let subtitle: String

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .foregroundColor(.dodgerTransBlue)
                .frame(width: 40, height: 40)
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(title)
                    .font(.bodyRegular17)
                    .foregroundColor(.chineseBlack)
                
                Text(subtitle)
                    .font(.caption1Regular12)
                    .foregroundColor(.romanSilver)
                    .padding(.top, 4)
            }
            .padding(.leading, 8)
        }
    }
}
