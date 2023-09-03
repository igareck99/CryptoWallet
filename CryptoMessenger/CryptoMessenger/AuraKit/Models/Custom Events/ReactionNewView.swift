import SwiftUI

struct ReactionNewView: View {
    
    let value: ReactionNewEvent
    
    var body: some View {
        Group {
            Text(value.emoji)
                .font(.regular(13))
                .foregroundColor(value.color)
        }
        .contentShape(Rectangle())
        .onTapGesture {
        }
        .frame(height: 28)
        .frame(width: value.width)
        .cornerRadius(30)
    }
}
