import Foundation

// MARK: - ProfileBackgroundPreviewConfigurator

enum ProfileBackgroundPreviewConfigurator {
    static func configuredViewController(delegate: ProfileBackgroundPreviewSceneDelegate?) -> ProfileBackgroundPreviewViewController {

        // MARK: - Internal Methods

        let viewController = ProfileBackgroundPreviewViewController()
        let presenter = ProfileBackgroundPreviewPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
