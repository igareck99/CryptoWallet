import Foundation

// MARK: - BlockedListConfigurator

enum BlockedListConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: BlockedListSceneDelegate?) -> BlockedUserContentView {
        let viewModel = BlockListViewModel()
        viewModel.delegate = delegate
        let view = BlockedUserContentView(viewModel: viewModel)
        return view
    }
}
