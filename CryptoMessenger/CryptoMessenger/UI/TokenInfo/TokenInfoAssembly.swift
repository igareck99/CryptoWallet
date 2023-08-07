import SwiftUI

enum TokenInfoAssembly {
    static func build(wallet: WalletInfo) -> some View {
        let viewModel = TokenInfoViewModel(address: wallet)
        let view = TokenInfoView(viewModel: viewModel)
        return view
    }
}
