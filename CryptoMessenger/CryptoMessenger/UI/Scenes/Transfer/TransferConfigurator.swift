import Foundation

// MARK: - TransferConfigurator

enum TransferConfigurator {

    // MARK: - Static Methods

    static func build(
        wallet: WalletInfo,
        coordinator: WalletCoordinatable
    ) -> TransferView {
        let viewModel = TransferViewModel(wallet: wallet, coordinator: coordinator)
		let view = TransferView(viewModel: viewModel)
        return view
    }
}
