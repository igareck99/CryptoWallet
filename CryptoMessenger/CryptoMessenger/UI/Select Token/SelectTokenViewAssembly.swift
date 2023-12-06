import SwiftUI

enum SelectTokenViewAssembly {
    static func build(
        addresses: [WalletInfo],
        showSelectToken: Binding<Bool>,
        address: Binding<WalletInfo>
    ) -> some View {
        let viewModel = SelectTokenViewModel(
            addresses: addresses,
            showSelectToken: showSelectToken,
            address: address
        )
        let view = SelectTokenView(viewModel: viewModel)
        return view
    }
}
