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
                .foregroundColor(.cyan)
                .frame(width: 40, height: 40)
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.regentGrayApprox)
                    .padding(.top, 4)
            }
            .padding(.leading, 8)
        }
    }
}
