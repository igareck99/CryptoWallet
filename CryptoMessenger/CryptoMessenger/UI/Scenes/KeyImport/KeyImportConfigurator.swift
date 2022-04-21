import Foundation

// MARK: - KeyImportConfigurator

enum KeyImportConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: KeyImportSceneDelegate?) -> KeyImportViewController {
        let viewController = KeyImportViewController()
		let userFlows = UserDefaultsService.shared
		let presenter = KeyImportPresenter(view: viewController, userFlows: userFlows)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
