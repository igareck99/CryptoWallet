import Foundation

// MARK: - AppLanguageConfigurator

enum AppLanguageConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: AppLanguageSceneDelegate?) -> AppLanguageViewController {
        let viewController = AppLanguageViewController()
        let presenter = AppLanguagePresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
