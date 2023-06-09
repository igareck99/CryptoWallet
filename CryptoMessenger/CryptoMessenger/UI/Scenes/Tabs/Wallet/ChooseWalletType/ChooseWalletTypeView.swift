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
        VStack(spacing: 0) {

            Text(R.string.localizable.transferChooseCurrency())
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.chineseBlack)
                .frame(height: 24)
                .padding(.vertical, 24)

            ForEach(wallletTypes, id: \.self) { item in
                ChooseWalletTypeCell(walletType: item)
                    .onTapGesture {
                        choosedWalletType = item
                        isSelectedWalletType = true
                        chooseWalletShow.toggle()
                    }
            }
            Spacer().frame(height: 24)
        }
    }
}
