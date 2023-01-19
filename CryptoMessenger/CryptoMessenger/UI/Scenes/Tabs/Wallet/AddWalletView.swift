import SwiftUI

// MARK: - AddWalletView

struct AddWalletView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: WalletViewModel
    @Binding var showAddWallet: Bool

    // MARK: - Body

    var body: some View {
        VStack(spacing: 18) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foreground(.darkGray(0.4))
                .padding(.top, 6)
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foreground(.blue(0.1))
                    R.image.transaction.bluePlus.image
                }
                Text(R.string.localizable.transactionAddWallet(), [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left)),
                    .font(.regular(17)),
                    .color(.blue())
                ])
                Spacer()
            }
            .padding(.leading, 16)
            .onDisappear {
                debugPrint("onDisappearAddWallet")
                showTabBar()
            }
            .onTapGesture {
                showAddWallet = false
                viewModel.send(.onImportKey)
            }
            Spacer()
        }
    }
}
