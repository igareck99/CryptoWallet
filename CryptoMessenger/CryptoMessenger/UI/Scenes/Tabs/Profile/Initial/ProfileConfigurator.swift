import Foundation

// MARK: - ProfileConfigurator

enum ProfileConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ProfileSceneDelegate?) -> ProfileView {
        let viewModel = ProfileViewModel()
        viewModel.delegate = delegate
        let view = ProfileView(viewModel: viewModel)
        return view
    }
}
