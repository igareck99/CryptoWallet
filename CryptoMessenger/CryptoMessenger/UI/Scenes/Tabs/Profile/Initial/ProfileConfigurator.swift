import Foundation

// MARK: - ProfileConfigurator

enum ProfileConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ProfileSceneDelegate?) -> ProfileView {
		let userSettings = UserDefaultsService.shared
		let viewModel = ProfileViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = ProfileView(viewModel: viewModel)
        return view
    }
}
