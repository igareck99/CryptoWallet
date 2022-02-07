import Foundation

// MARK: - ChatSettingsConfigurator

enum ChatSettingsConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChatSettingsSceneDelegate?) -> ChatSettingsView {
        let viewModel = ChatSettingsViewModel()
        viewModel.delegate = delegate
        let view = ChatSettingsView(viewModel: viewModel)
        return view
    }
}
