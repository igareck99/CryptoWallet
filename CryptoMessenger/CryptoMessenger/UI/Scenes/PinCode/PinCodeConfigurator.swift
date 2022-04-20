import Foundation

// MARK: - PinCodeConfigurator

enum PinCodeConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: PinCodeSceneDelegate?) -> PinCodeViewController {
        let viewController = PinCodeViewController()
		let userSettings = UserDefaultsService.shared
        let presenter = PinCodePresenter(
			view: viewController,
			userSettings: userSettings
		)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
