import Foundation

// MARK: - ProfileConfigurator

enum ProfileConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: ProfileSceneDelegate?) -> ProfileViewController {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
