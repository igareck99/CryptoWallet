import Foundation

// MARK: - SessionConfigurator

enum SessionConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: SessionSceneDelegate?) -> SessionListView {
		let userSettings = UserDefaultsService.shared
        let viewModel = SessionViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = SessionListView(viewModel: viewModel)
        return view
    }
}
