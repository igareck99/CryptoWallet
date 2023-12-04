import SwiftUI

enum ImportKeyViewAssembly {
    static func build(coordinator: ImportKeyCoordinatable) -> some View {
        let viewModel = ImportKeyViewModel(coordinator: coordinator)
        return ImportKeyView(viewModel: viewModel)
    }
}
