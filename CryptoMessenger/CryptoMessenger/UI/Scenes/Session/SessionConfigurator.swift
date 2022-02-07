import Foundation

// MARK: - SessionConfigurator

enum SessionConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: SessionSceneDelegate?) -> SessionListView {
        let viewModel = SessionViewModel()
        viewModel.delegate = delegate
        let view = SessionListView(viewModel: viewModel)
        return view
    }
}
