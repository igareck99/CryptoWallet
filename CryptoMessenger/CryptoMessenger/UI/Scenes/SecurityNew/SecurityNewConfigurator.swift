import Foundation

// MARK: - SecurityNewConfigurator

enum SecurityNewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: SecurityNewSceneDelegate?) -> SecurityNewView {
		let userSettings = UserDefaultsService.shared
        let viewModel = SecurityNewViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = SecurityNewView(viewModel: viewModel)
        return view
    }
}
