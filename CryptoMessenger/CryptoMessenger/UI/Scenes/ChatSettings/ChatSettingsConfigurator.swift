import Foundation

// MARK: - ChatSettingsConfigurator

enum ChatSettingsConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChatSettingsSceneDelegate?) -> ChatSettingsView {
		let userSettings = UserDefaultsService.shared
        let viewModel = ChatSettingsViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = ChatSettingsView(viewModel: viewModel)
        return view
    }
}
