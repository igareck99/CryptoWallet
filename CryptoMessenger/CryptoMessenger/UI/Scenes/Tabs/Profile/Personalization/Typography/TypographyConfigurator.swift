import Foundation

// MARK: - TypographyConfigurator

enum TypographyConfigurator {
    static func configuredViewController(delegate: TypographySceneDelegate?) -> TypographyViewController {

        // MARK: - Internal Methods

        let viewController = TypographyViewController()
        let presenter = TypographyPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
