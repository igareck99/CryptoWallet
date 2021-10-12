import Foundation

// MARK: - ProfileNetworkDetailConfigurator

enum ProfileNetworkDetailConfigurator {
    static func configuredViewController(delegate: ProfileNetworkDetailSceneDelegate?)
    -> ProfileNetworkDetailViewController {

        // MARK: - Internal Methods

        let viewController = ProfileNetworkDetailViewController()
        let presenter = ProfileNetworkDetailPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
