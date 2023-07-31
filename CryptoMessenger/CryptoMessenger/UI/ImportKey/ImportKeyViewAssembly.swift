import SwiftUI

// MARK: - ImportKeyConfigurator

enum ImportKeyViewAssembly {

    // MARK: - Static Methods

    static func build(coordinator: ImportKeyCoordinatable) -> some View {
        let viewModel = ImportKeyViewModel(coordinator: coordinator)
        return ImportKeyView(viewModel: viewModel)
    }
}
