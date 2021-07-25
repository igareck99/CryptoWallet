import Foundation

// MARK: - GenerationInfoConfigurator

enum GenerationInfoConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: GenerationInfoSceneDelegate?) -> GenerationInfoViewController {
        let viewController = GenerationInfoViewController()
        let presenter = GenerationInfoPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
