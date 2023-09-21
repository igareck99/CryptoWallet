import SwiftUI

struct SystemEventView: View {
    let model: SystemEvent

    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            Spacer()
            Text(model.text)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(model.textColor)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(model.backColor)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            Spacer()
        }
        .onTapGesture {
            model.onTap()
        }
    }
}
