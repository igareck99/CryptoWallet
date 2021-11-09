import Foundation

// MARK: - BlackListConfigurator

enum BlackListConfigurator {
    static func configuredViewController(delegate: BlackListSceneDelegate?) -> BlackListViewController {

        // MARK: - Internal Methods

        let viewController = BlackListViewController()
        let presenter = BlackListPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
