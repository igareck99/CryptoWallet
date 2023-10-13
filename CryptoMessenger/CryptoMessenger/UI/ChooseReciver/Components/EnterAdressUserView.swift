import SwiftUI

// MARK: - EnterAdressUserView

struct EnterAdressUserView: View {

    // MARK: - Internal Properties

    @Binding var adress: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    Color.dodgerTransBlue
                    Text("A")
                        .foregroundColor(.white)
                        .font(.title2Regular22)
                }
                .scaledToFill()
                .frame(width: 40, height: 40)
                .cornerRadius(20)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text(R.string.localizable.enterAdressEnterAdress())
                            .font(.subheadlineMedium15)
                            .foregroundColor(.chineseBlack)
                            .padding(.top, 12)
                    }
                    Text(adress)
                        .font(.footnoteRegular13)
                        .foregroundColor(.romanSilver)
                        .padding(.bottom, 12)
                }
                .frame(height: 64)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}
