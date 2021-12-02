import Foundation

// MARK: - ProfileConfigurator

enum ProfileConfigurator {

    // MARK: - Static Methods

    static func configuredViewController(delegate: ProfileSceneDelegate?) -> ProfileViewController {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }

    static func configuredView(delegate: ProfileSceneDelegate?) -> ProfileMainView {
        //let viewModel = ChatHistoryViewModel()
        //viewModel.delegate = delegate
        var view = ProfileMainView(profile: ProfileUserItem.getProfile())
        return view
    }
}
