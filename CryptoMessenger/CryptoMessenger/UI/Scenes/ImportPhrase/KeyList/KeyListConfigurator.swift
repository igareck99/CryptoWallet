import Foundation

// MARK: - KeyListConfigurator

enum KeyListConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: KeyListSceneDelegate?) -> KeyListView {
		let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = KeyListViewModel(userCredentialsStorage: userCredentialsStorage)
        viewModel.delegate = delegate
        let view = KeyListView(viewModel: viewModel)
        return view
    }
}
