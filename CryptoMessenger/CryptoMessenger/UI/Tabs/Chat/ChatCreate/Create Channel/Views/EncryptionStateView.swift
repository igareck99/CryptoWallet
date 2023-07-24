import SwiftUI

struct EncryptionStateView: View {
    
    let title: String
    let text: String
    @Binding var isEncrypted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(.chineseBlack)
                
                Spacer()
                
                Toggle("", isOn: $isEncrypted)
            }
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.romanSilver)
                .padding(.top, 8)
        }
        .onTapGesture {
            isEncrypted.toggle()
        }
    }
}
