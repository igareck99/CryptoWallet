import SwiftUI

// MARK: - WalletManagerView

struct WalletManagerView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: WalletManagerViewModel
    @State var showSecretPhraseAlert = false

    // MARK: - Body

    var body: some View {
        content
            .navigationBarHidden(false)
            .onAppear {
                viewModel.send(.onAppear)
            }
            .onDisappear {
                showTabBar()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.walletManagerTitle())
                        .font(.bold(15))
                }
            }
    }
    // MARK: - Private Properties

    private var content: some View {
        VStack {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.top, 16)
                Text(R.string.localizable.chatSettingsReserveCopy().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                ReserveCellView(text: R.string.localizable.walletManagerSecretPhrase())
                    .background(.white())
                    .onTapGesture {
                        viewModel.send(.onKeyList)
                    }
                    .padding(.top, 21)
                    .padding(.horizontal, 16)
                Divider()
                    .padding(.top, 21)
                Text(R.string.localizable.walletManagerWallets().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                keyManagerCell
                    .background(.white())
                    .frame(height: 44)
                    .onTapGesture {
                        viewModel.send(.onPhrase)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
            }
            Spacer()
        }
    }

    private var keyManagerCell: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(R.string.localizable.walletManagerKeyManager(), [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left)),
                    .font(.regular(16)),
                    .color(.black())
                ])
                Text(R.string.localizable.walletManagerAddDeleteKeys(), [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left)),
                    .font(.regular(12)),
                    .color(.darkGray())
                ])
            }
            Spacer()
            R.image.additionalMenu.grayArrow.image
        }
    }
}
