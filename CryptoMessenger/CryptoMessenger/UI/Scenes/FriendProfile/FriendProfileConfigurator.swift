import Foundation

// MARK: - FriendProfileConfigurator

enum FriendProfileConfigurator {
    static func configuredViewController(delegate: FriendProfileSceneDelegate?) -> FriendProfileViewController {

        // MARK: - Internal Methods

        let viewController = FriendProfileViewController()
        let presenter = FriendProfilePresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
