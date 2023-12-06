import SwiftUI

enum WatchKeyViewAssembly {
    static func make(
        seed: String,
        type: WatchKeyViewType,
        coordinator: WatchKeyViewModelDelegate
    ) -> some View {
        let viewModel = WatchKeyViewModel(
            generatedKey: seed,
            coordinator: coordinator,
            type: type
        )
        let view = WatchKeyView(viewModel: viewModel)
        return view
    }
}
