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
                    Text(viewModel.sources.walletManagerTitle)
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
                Text(viewModel.sources.chatSettingsReserveCopy.uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                ReserveCellView(text: viewModel.sources.walletManagerSecretPhrase)
                    .background(.white())
                    .onTapGesture {
                        viewModel.send(.onPhrase)
                    }
                    .padding(.top, 21)
                    .padding(.horizontal, 16)
                Divider()
                    .padding(.top, 21)
                Text(viewModel.sources.walletManagerWallets.uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                keyManagerCell
                    .background(.white())
                    .frame(height: 44)
                    .onTapGesture {
                        viewModel.send(.onKeyList)
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
                Text(viewModel.sources.walletManagerKeyManager, [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left)),
                    .font(.regular(16)),
                    .color(.black())
                ])
                Text(viewModel.sources.walletManagerAddDeleteKeys, [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left)),
                    .font(.regular(12)),
                    .color(.darkGray())
                ])
            }
            Spacer()
            viewModel.sources.grayArrow
        }
    }
}
