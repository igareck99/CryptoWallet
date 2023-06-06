import Foundation

// MARK: - VerificationConfigurator

enum VerificationConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: VerificationSceneDelegate?) -> VerificationViewController {
        let viewController = VerificationViewController()
		let keychainService = KeychainService.shared
        let userSettings = UserDefaultsService.shared
        let presenter = VerificationPresenter(
            view: viewController,
            keychainService: keychainService,
            matrixUseCase: MatrixUseCase.shared,
            userSettings: userSettings
        )
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
