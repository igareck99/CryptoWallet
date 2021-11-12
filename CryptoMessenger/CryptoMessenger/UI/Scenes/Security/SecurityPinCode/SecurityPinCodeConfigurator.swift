import Foundation

// MARK: - SecurityPinCodeConfigurator

enum SecurityPinCodeConfigurator {
    static func configuredViewController(delegate: SecurityPinCodeSceneDelegate?) -> SecurityPinCodeViewController {

        // MARK: - Internal Methods

        let viewController = SecurityPinCodeViewController()
        let presenter = SecurityPinCodePresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
