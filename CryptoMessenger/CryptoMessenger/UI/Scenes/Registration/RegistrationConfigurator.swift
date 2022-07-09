import Foundation

// MARK: - RegistrationConfigurator

enum RegistrationConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: RegistrationSceneDelegate?) -> RegistrationViewController {
        let viewController = RegistrationViewController()
		let userCredentials = UserDefaultsService.shared
        let presenter = RegistrationPresenter(
			view: viewController,
			userCredentials: userCredentials,
			keychainService: KeychainService.shared
		)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
