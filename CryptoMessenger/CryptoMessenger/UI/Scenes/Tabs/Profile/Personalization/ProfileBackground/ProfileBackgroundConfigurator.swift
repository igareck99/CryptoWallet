import Foundation

// MARK: - ProfileBackgroundConfigurator

enum ProfileBackgroundConfigurator {
    static func configuredViewController(delegate: ProfileBackgroundSceneDelegate?) -> ProfileBackgroundViewController {

        // MARK: - Internal Methods

        let viewController = ProfileBackgroundViewController()
        let presenter = ProfileBackgroundPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
