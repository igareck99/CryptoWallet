import Foundation

// MARK: - VerificationConfigurator

enum VerificationConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: VerificationSceneDelegate?) -> VerificationViewController {
        let viewController = VerificationViewController()
        let presenter = VerificationPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
