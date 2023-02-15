import Foundation

// MARK: - ImportKeyConfigurator

enum ImportKeyConfigurator {

    // MARK: - Static Methods

    static func configuredView(
        delegate: ImportKeySceneDelegate?,
        navController: UINavigationController? = nil
    ) -> ImportKeyView {
        let viewModel = ImportKeyViewModel()
        viewModel.delegate = delegate
        viewModel.navController = navController
        let view = ImportKeyView(viewModel: viewModel)
        return view
    }
}
