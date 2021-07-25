import Foundation

// MARK: - KeyImportConfigurator

enum KeyImportConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: KeyImportSceneDelegate?) -> KeyImportViewController {
        let viewController = KeyImportViewController()
        let presenter = KeyImportPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
