import Foundation

// MARK: - WalletNewConfigurator

enum WalletNewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: WalletNewSceneDelegate?) -> WalletNewView {
		let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = WalletNewViewModel(userCredentialsStorage: userCredentialsStorage)
        viewModel.delegate = delegate
        let view = WalletNewView(viewModel: viewModel)
        return view
    }
}
