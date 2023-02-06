import SwiftUI

// MARK: - EnterAdressUserView

struct EnterAdressUserView: View {

    // MARK: - Internal Properties

    @Binding var adress: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    Color(.lightBlue())
                    Text("A")
                        .foreground(.white())
                        .font(.medium(22))
                }
                .scaledToFill()
                .frame(width: 40, height: 40)
                .cornerRadius(20)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("Введите адресс")
                            .font(.semibold(15))
                            .foreground(.black())
                            .padding(.top, 12)
                    }
                    Text(adress)
                        .font(.regular(13))
                        .foreground(.darkGray())
                        .padding(.bottom, 12)
                }
                .frame(height: 64)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}
