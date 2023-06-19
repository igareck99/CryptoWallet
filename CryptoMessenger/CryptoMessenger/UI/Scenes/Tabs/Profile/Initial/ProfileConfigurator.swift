import Foundation

// MARK: - ProfileConfigurator

enum ProfileConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ProfileSceneDelegate?) -> ProfileView {
		let userSettings = UserDefaultsService.shared
		let keychainService = KeychainService.shared
		let viewModel = ProfileViewModel(
			userSettings: userSettings,
			keychainService: keychainService
		)
        //viewModel.delegate = delegate
        let view = ProfileView(viewModel: viewModel)
        return view
    }
}
