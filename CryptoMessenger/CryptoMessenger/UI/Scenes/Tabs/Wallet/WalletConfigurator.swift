import Foundation

// MARK: - WalletConfigurator

enum WalletConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: WalletSceneDelegate?) -> WalletViewController {
        let viewController = WalletViewController()
        let presenter = WalletPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
