import Foundation

// MARK: - ProfileDetailConfigurator

enum ProfileDetailConfigurator {
    static func configuredViewController(delegate: ProfileDetailSceneDelegate?) -> ProfileDetailViewController {
        let viewController = ProfileDetailViewController()
        let presenter = ProfileDetailPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
