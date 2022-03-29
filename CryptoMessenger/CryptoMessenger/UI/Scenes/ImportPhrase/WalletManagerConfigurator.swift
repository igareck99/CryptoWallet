import Foundation

// MARK: - WalletManagerConfigurator

enum WalletManagerConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: WalletManagerSceneDelegate?) -> WalletManagerView {
        let viewModel = WalletManagerViewModel()
        viewModel.delegate = delegate
        let view = WalletManagerView(viewModel: viewModel)
        return view
    }
}
