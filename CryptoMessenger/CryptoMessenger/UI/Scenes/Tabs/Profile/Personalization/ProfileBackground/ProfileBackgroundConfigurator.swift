import Foundation

// MARK: - ProfileBackgroundConfigurator

enum ProfileBackgroundConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: ProfileBackgroundSceneDelegate?) -> ProfileBackgroundViewController {
        let viewController = ProfileBackgroundViewController()
        let presenter = ProfileBackgroundPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
