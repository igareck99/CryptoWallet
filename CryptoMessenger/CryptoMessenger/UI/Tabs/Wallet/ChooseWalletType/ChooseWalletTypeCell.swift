import SwiftUI

// MARK: - ChooseWalletTypeCell

struct ChooseWalletTypeCell: View {

    // MARK: - Internal Properties

    var walletType: WalletType

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            Text(walletType.compositeTitle)
                .lineLimit(1)
                .font(.bodyRegular17)
                .padding(.trailing, 16)
            Spacer()
            Divider()
                .foregroundColor(.romanSilver)
                .frame(height: 0.5)
        }
        .padding(.leading, 16)
        .frame(height: 44)
    }
}
