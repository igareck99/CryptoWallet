import Foundation

// MARK: - AboutAppConfigurator

enum AboutAppConfigurator {
    static func configuredViewController(delegate: AboutAppSceneDelegate?) -> AboutAppViewController {

        // MARK: - Internal Methods

        let viewController = AboutAppViewController()
        let presenter = AboutAppPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
