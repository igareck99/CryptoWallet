import Foundation

// MARK: - AppLanguageConfigurator

enum AppLanguageConfigurator {
    static func configuredViewController(delegate: AppLanguageSceneDelegate?) -> AppLanguageViewController {

        // MARK: - Internal Methods

        let viewController = AppLanguageViewController()
        let presenter = AppLanguagePresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
