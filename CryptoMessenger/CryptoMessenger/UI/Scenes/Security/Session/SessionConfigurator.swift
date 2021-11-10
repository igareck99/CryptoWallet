import Foundation

// MARK: - SessionConfigurator

enum SessionConfigurator {
    static func configuredViewController(delegate: SessionSceneDelegate?) -> SessionViewController {

        // MARK: - Internal Methods

        let viewController = SessionViewController()
        let presenter = SessionPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
