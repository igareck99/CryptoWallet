import Foundation

// MARK: - PhraseManagerConfigurator

enum PhraseManagerConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PhraseManagerSceneDelegate?) -> PhraseManagerView {
		let userCredentialsStorage = UserDefaultsService.shared
        let viewModel = PhraseManagerViewModel(userCredentialsStorage: userCredentialsStorage)
        viewModel.delegate = delegate
        let view = PhraseManagerView(viewModel: viewModel)
        return view
    }
}
