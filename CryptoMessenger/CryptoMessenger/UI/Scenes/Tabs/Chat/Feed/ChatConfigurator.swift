import Foundation

// MARK: - ChatConfigurator

enum ChatConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: ChatSceneDelegate?) -> ChatViewController {
        let viewController = ChatViewController()
        let presenter = ChatPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
