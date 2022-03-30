import Foundation

// MARK: - KeyListConfigurator

enum KeyListConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: KeyListSceneDelegate?) -> KeyListView {
        let viewModel = KeyListViewModel()
        viewModel.delegate = delegate
        let view = KeyListView(viewModel: viewModel)
        return view
    }
}
