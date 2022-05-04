import Foundation

// MARK: - VerificationConfigurator

enum VerificationConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: VerificationSceneDelegate?) -> VerificationViewController {
        let viewController = VerificationViewController()
		let userCredentials = UserDefaultsService.shared
		let presenter = VerificationPresenter(
			view: viewController,
			userCredentials: userCredentials,
			matrixUseCase: MatrixUseCase.shared
		)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
