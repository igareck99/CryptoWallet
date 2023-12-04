import SwiftUI

enum AboutAppAssembly {
    static func build() -> some View {
        let resources = AboutAppSources.self
        let viewModel = AboutAppViewModel(resources: resources)
        let view = AboutAppView(viewModel: viewModel)
        return view
    }
}
