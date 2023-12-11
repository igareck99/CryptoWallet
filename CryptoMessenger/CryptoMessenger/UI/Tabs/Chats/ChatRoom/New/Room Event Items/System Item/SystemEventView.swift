import SwiftUI

struct SystemEventView: View {
    let model: SystemEvent

    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            Spacer()
            Text(model.text)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .font(.subheadline2Regular14)
                .foregroundColor(model.textColor)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 2)
                .background(model.backColor)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            Spacer()
        }
        .onTapGesture {
            model.onTap()
        }
    }
}
