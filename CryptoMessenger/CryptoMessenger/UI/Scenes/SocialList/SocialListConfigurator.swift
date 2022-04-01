import Foundation

// MARK: - SocialListConfigurator

enum SocialListConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: SocialListSceneDelegate?) -> SocialListView {
        let viewModel = SocialListViewModel()
        viewModel.delegate = delegate
        let view = SocialListView(viewModel: viewModel)
        return view
    }
}
