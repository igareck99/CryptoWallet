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
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foreground(.darkGray(0.4))
                .padding(.top, 6)
            ForEach(wallletTypes, id: \.self) { item in
                ChooseWalletTypeCell(walletType: item)
                    .onTapGesture {
                        choosedWalletType = item
                        isSelectedWalletType = true
                        chooseWalletShow.toggle()
                    }
            }
            Spacer()
        }
    }
}
