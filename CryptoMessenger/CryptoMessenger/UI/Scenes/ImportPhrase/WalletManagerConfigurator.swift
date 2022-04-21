import Foundation

// MARK: - WalletManagerConfigurator

enum WalletManagerConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: WalletManagerSceneDelegate?) -> WalletManagerView {
		let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = WalletManagerViewModel(userCredentialsStorage: userCredentialsStorage)
        viewModel.delegate = delegate
        let view = WalletManagerView(viewModel: viewModel)
        return view
    }
}
