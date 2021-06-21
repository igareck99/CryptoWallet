import Foundation

// MARK: StartConfigurator

enum StartConfigurator {

    // MARK: - Internal Methods

    static func configuredViewController(delegate: StartPresenterDelegate?) -> StartViewController {
        let viewController = StartViewController()
        let presenter = StartPresenter(view: viewController, userCredentialsStorage: UserCredentialsStorageService())
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
