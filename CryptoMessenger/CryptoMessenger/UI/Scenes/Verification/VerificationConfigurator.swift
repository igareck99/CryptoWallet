import Foundation

// MARK: - VerificationConfigurator

enum VerificationConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: VerificationSceneDelegate?) -> VerificationViewController {
        let viewController = VerificationViewController()
		let keychainService = KeychainService.shared
		let presenter = VerificationPresenter(
			view: viewController,
			keychainService: keychainService,
			matrixUseCase: MatrixUseCase.shared
		)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
