import SwiftUI

// MARK: - AboutAppAssembly

enum AboutAppAssembly {

    // MARK: - Static Methods

    static func build(_ coordinator: ProfileFlowCoordinatorProtocol) -> some View {
        let sources = AboutAppSources.self
        let viewModel = AboutAppViewModel(sources: sources)
        let view = AboutAppNewView(viewModel: viewModel)
        return view
    }
}
