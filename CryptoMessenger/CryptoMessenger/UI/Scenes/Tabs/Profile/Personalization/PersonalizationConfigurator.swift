import Foundation

// MARK: - PersonalizationConfigurator

enum PersonalizationConfigurator {
    static func configuredViewController(delegate: PersonalizationSceneDelegate?) -> PersonalizationViewController {

        // MARK: - Internal Methods

        let viewController = PersonalizationViewController()
        let presenter = PersonalizationPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
