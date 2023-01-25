import SwiftUI

enum ChannelType {
    case publicChannel
    case privateChannel
}

struct ChannelTypeView: View {
    
    let title: String
    let text: String
    let channelType: ChannelType
    @Binding var isSelected: Bool
    let onSelect: (ChannelType) -> Void
 
     var body: some View {
         VStack(alignment: .leading, spacing: 0) {
             
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(.black)
             
            HStack(spacing: 0) {
                Text(text)
                    .font(.system(size: 12))
                    .foreground(.darkGray())
                    .padding(.top, 4)
                Spacer()
                VStack(alignment: .center) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.azureRadianceApprox)
                        .opacity(isSelected ? 1 : 0)
                }
                .padding(.trailing, 8)
            }
        }
        .onTapGesture {
            guard !isSelected else { return }
            isSelected.toggle()
            onSelect(channelType)
        }
    }
}