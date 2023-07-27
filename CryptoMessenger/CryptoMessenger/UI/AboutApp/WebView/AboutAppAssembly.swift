import SwiftUI

// MARK: - AboutAppAssembly

enum AboutAppAssembly {

    // MARK: - Static Methods

    static func build() -> some View {
        let sources = AboutAppSources.self
        let viewModel = AboutAppViewModel(sources: sources)
        let view = AboutAppView(viewModel: viewModel)
        return view
    }
}
