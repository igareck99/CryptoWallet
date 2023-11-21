import SwiftUI

// MARK: - TransferConfigurator

enum TransferConfigurator {

    // MARK: - Static Methods

    static func build(
        wallet: WalletInfo,
        coordinator: TransferViewCoordinatable
    ) -> some View {
        let viewModel = TransferViewModel(
            wallet: wallet,
            coordinator: coordinator
        )
		let view = TransferView(viewModel: viewModel)
        return view
    }
}
