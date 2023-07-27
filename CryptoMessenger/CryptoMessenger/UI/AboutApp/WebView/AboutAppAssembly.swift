import SwiftUI

// MARK: - AboutAppAssembly

enum AboutAppAssembly {

    // MARK: - Static Methods

    static func build() -> some View {
        let resources = AboutAppSources.self
        let viewModel = AboutAppViewModel(resources: resources)
        let view = AboutAppView(viewModel: viewModel)
        return view
    }
}
