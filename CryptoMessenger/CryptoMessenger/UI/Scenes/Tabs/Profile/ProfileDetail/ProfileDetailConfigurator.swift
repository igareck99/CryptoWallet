import Foundation

// MARK: - ProfileDetailConfigurator

enum ProfileDetailConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ProfileDetailSceneDelegate?) -> ProfileDetailView {
        let viewModel = ProfileDetailViewModel()
        viewModel.delegate = delegate
        let view = ProfileDetailView(viewModel: viewModel)
        return view
    }
}
