import Foundation

// MARK: - PinCodeConfigurator

enum PinCodeConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: PinCodeSceneDelegate?) -> PinCodeViewController {
        let viewController = PinCodeViewController()
        let presenter = PinCodePresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
