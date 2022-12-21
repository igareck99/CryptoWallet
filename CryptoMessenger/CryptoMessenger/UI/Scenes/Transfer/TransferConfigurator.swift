import Foundation

// MARK: - TransferConfigurator

enum TransferConfigurator {

    // MARK: - Static Methods

    static func configuredView(
		wallet: WalletInfo,
		delegate: TransferSceneDelegate?
	) -> TransferView {
        let viewModel = TransferViewModel(wallet: wallet)
        viewModel.delegate = delegate
		let view = TransferView(viewModel: viewModel)
        return view
    }
}
