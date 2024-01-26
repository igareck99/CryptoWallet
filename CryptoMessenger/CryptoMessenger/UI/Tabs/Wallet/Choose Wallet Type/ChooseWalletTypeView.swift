import SwiftUI

// MARK: - ChooseWalletTypeView

struct ChooseWalletTypeView: View {

    // MARK: - Internal Properties

    @Binding var chooseWalletShow: Bool
    @Binding var choosedWalletType: WalletType
    @Binding var isSelectedWalletType: Bool
    let wallletTypes: [WalletType]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .center) {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width,
                           height: 42)
                    .foreground(.clear)
                Text(R.string.localizable.transferChooseCurrency())
                    .font(.bodySemibold17)
                    .foregroundColor(.chineseBlack)
            }
            ForEach(wallletTypes, id: \.self) { item in
                ChooseWalletTypeCell(walletType: item)
                    .onTapGesture {
                        choosedWalletType = item
                        isSelectedWalletType = true
                        chooseWalletShow.toggle()
                    }
            }
        }
    }
}
