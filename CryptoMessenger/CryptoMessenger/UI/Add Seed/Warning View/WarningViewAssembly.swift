import SwiftUI

enum WarningViewAssembly {
    static func build(coordinator: WarningViewModelDelegate) -> some View {
        let viewModel = WarningViewModel(coordinator: coordinator)
        let view = WarningView(viewModel: viewModel)
        return view
    }
}
