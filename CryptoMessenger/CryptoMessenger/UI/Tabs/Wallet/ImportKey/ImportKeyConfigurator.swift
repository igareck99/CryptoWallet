import SwiftUI

// MARK: - ImportKeyConfigurator

enum ImportKeyConfigurator {

    // MARK: - Static Methods

    static func build(coordinator: WalletCoordinatable) -> some View {
        let viewModel = ImportKeyViewModel(coordinator: coordinator)
        return ImportKeyView(viewModel: viewModel)
    }
}
