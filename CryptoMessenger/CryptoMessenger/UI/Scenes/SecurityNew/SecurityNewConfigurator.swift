import Foundation

// MARK: - SecurityNewConfigurator

enum SecurityNewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: SecurityNewSceneDelegate?) -> SecurityNewView {
        let viewModel = SecurityNewViewModel()
        viewModel.delegate = delegate
        let view = SecurityNewView(viewModel: viewModel)
        return view
    }
}