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
                    Text(viewModel.resources.walletManagerTitle)
                        .font(.system(size: 15, weight: .bold))
                }
            }
    }
    // MARK: - Private Properties

    private var content: some View {
        VStack {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.top, 16)
                Text(viewModel.resources.chatSettingsReserveCopy.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(viewModel.resources.textColor)
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                ReserveCellView(text: viewModel.resources.walletManagerSecretPhrase)
                    .background(viewModel.resources.background)
                    .onTapGesture {
                        viewModel.send(.onPhrase)
                    }
                    .padding(.top, 21)
                    .padding(.horizontal, 16)
                Divider()
                    .padding(.top, 21)
                Text(viewModel.resources.walletManagerWallets.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(viewModel.resources.textColor)
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                keyManagerCell
                    .background(viewModel.resources.background)
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
                Text(viewModel.resources.walletManagerKeyManager, [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left))
                ])
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(viewModel.resources.titleColor)
                Text(viewModel.resources.walletManagerAddDeleteKeys, [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left))
                ])
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(viewModel.resources.textColor)
            }
            Spacer()
            viewModel.resources.grayArrow
        }
    }
}
