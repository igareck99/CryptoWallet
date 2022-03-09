import Foundation

// MARK: - ImportKeyConfigurator

enum ImportKeyConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ImportKeySceneDelegate?) -> ImportKeyView {
        let viewModel = ImportKeyViewModel()
        viewModel.delegate = delegate
        let view = ImportKeyView(viewModel: viewModel)
        return view
    }
}
