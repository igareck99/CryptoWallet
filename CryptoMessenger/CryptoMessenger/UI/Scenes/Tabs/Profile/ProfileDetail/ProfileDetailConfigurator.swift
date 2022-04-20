import Foundation

// MARK: - ProfileDetailConfigurator

enum ProfileDetailConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ProfileDetailSceneDelegate?) -> ProfileDetailView {
		let userSettings = UserDefaultsService.shared
		let viewModel = ProfileDetailViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = ProfileDetailView(viewModel: viewModel)
        return view
    }
}
