import SwiftUI

struct TokenView: View {

    let model: TokenViewModel

    var body: some View {
        HStack(alignment: .center ) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.dodgerTransBlue)
                        .frame(width: 40, height: 40)
                    R.image.chat.logo.image
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(model.address)
                        .font(.subheadlineMedium15)
                        .frame(height: 22)
                    Text(model.value)
                        .font(.caption1Regular12)
                        .foreground(.romanSilver)
                        .frame(height: 20)
                }
            }
            Spacer()
        }
        .onTapGesture {
            model.onTap()
        }
    }
}
