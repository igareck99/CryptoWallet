import Foundation

// MARK: - SessionDetailConfigurator

enum SessionDetailConfigurator {
    static func configuredViewController(delegate: SessionDetailSceneDelegate?) -> SessionDetailViewController {

        // MARK: - Internal Methods

        let viewController = SessionDetailViewController()
        let presenter = SessionDetailPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
