import Foundation

// MARK: - WalletManagerConfigurator

enum WalletManagerConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: WalletManagerSceneDelegate?) -> WalletManagerView {
		let keychainService = KeychainService.shared
        let viewModel = WalletManagerViewModel(keychainService: keychainService)
        viewModel.delegate = delegate
        let view = WalletManagerView(viewModel: viewModel)
        return view
    }
}
