import Foundation

// MARK: - RegistrationConfigurator

enum RegistrationConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: RegistrationSceneDelegate?) -> RegistrationViewController {
        let viewController = RegistrationViewController()
        let presenter = RegistrationPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
