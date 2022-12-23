import Foundation

// MARK: - WalletConfigurator

enum WalletConfigurator {

    // MARK: - Static Methods

    static func configuredView(
		delegate: WalletSceneDelegate?,
		onTransactionEndHelper: @escaping ( @escaping (TransactionResult) -> Void) -> Void
	) -> WalletView {
		let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = WalletViewModel(
			userCredentialsStorage: userCredentialsStorage,
			onTransactionEndHelper: onTransactionEndHelper
		)
        viewModel.delegate = delegate
        let view = WalletView(viewModel: viewModel)
        return view
    }
}
