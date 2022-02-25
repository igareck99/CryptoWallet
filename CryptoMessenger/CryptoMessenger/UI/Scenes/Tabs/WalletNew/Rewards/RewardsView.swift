import SwiftUI

// MARK: - RewardsView

struct RewardsView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: WalletNewViewModel

    // MARK: - Body

    var body: some View {
        VStack {

        }
        .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(R.string.localizable.tabWallet())
                            .font(.bold(15))
                    }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        R.image.wallet.settings.image
                    }
                }
                }
    }
}
