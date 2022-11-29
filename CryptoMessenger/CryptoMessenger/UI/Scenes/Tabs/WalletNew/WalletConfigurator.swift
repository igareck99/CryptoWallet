import Foundation

// MARK: - WalletConfigurator

enum WalletConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: WalletSceneDelegate?) -> WalletView {
		let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = WalletViewModel(userCredentialsStorage: userCredentialsStorage)
        viewModel.delegate = delegate
        let view = WalletView(viewModel: viewModel)
        return view
    }
}
