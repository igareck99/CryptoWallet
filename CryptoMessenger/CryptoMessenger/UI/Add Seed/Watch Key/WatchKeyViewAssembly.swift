import SwiftUI

enum WatchKeyViewAssembly {
    static func make(
        seed: String,
        coordinator: WatchKeyViewModelDelegate
    ) -> some View {
        let viewModel = WatchKeyViewModel(
            generatedKey: seed,
            coordinator: coordinator
        )
        let view = WatchKeyView(viewModel: viewModel)
        return view
    }
}
