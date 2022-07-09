import Foundation

// MARK: - ProfileDetailConfigurator

enum ProfileDetailConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ProfileDetailSceneDelegate?) -> ProfileDetailView {
		let userSettings = UserDefaultsService.shared
		let keychainService = KeychainService.shared
		let viewModel = ProfileDetailViewModel(
			userSettings: userSettings,
			keychainService: keychainService
		)
        viewModel.delegate = delegate
        let view = ProfileDetailView(viewModel: viewModel)
        return view
    }
}
