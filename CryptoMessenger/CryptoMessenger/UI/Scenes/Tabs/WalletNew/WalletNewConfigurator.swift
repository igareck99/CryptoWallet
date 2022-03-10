import Foundation

// MARK: - WalletNewConfigurator

enum WalletNewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: WalletNewSceneDelegate?) -> WalletNewView {
        let viewModel = WalletNewViewModel()
        viewModel.delegate = delegate
        let view = WalletNewView(viewModel: viewModel)
        return view
    }
}
