import SwiftUI

// MARK: - ChooseWalletTypeCell

struct ChooseWalletTypeCell: View {

    // MARK: - Internal Properties

    var walletType: WalletType

    // MARK: - Body

    var body: some View {
        HStack {
        HStack(alignment: .center,
               spacing: 16) {
            switch walletType {
            case .ethereum:
                ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foreground(.purple(0.1))
                R.image.importKey.ethereumLabel.image
                }
                Text("ETH (Ethereum)")
                    .font(.bold(15))
            case .bitcoin:
                ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foreground(.lightOrange(0.1))
                R.image.importKey.bitcoinLabel.image
                }
                Text("BTC (Bitcoin)")
                    .font(.bold(15))
            case .binance:
                ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foreground(.lightOrange(0.1))
                R.image.importKey.bitcoinLabel.image
                }
                Text("BNC")
                    .font(.bold(15))
            case .aur:
                ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foreground(.blue(0.1))
                R.image.chat.logo.image
                }
                Text("AUR (Aura)")
                    .font(.bold(15))
            }
        }               .padding(.leading, 16)
               .frame(height: 64)
            Spacer()
    }
    }
}
