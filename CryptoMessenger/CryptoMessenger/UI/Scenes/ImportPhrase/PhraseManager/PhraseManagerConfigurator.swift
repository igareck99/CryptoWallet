import Foundation

// MARK: - PhraseManagerConfigurator

enum PhraseManagerConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PhraseManagerSceneDelegate?) -> PhraseManagerView {
		let keychainService = KeychainService.shared
        let viewModel = PhraseManagerViewModel(keychainService: keychainService)
        viewModel.delegate = delegate
        let view = PhraseManagerView(viewModel: viewModel)
        return view
    }
}
