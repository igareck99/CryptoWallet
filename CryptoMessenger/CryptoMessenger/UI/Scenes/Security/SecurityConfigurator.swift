import Foundation

// MARK: - SecurityConfigurator

enum SecurityConfigurator {
    static func configuredViewController(delegate: SecuritySceneDelegate?) -> SecurityViewController {

        // MARK: - Internal Methods

        let viewController = SecurityViewController()
        let presenter = SecurityPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
