import SwiftUI

enum GeneratePhraseViewAssembly {
    static func build(coordinator: PhraseGeneratable) -> some View {
        let viewModel = GeneratePhraseViewModel(
            coordinator: coordinator,
            isBackButtonHidden: true
        )
        let view = GeneratePhraseView(viewModel: viewModel)
        let router = GeneratePhraseRouter(
            state: GeneratePhraseState.shared,
            factory: ViewsBaseFactory.self
            ) {
            view
        }
        coordinator.update(router: router)
        return router
    }

    static func make(coordinator: PhraseGeneratable) -> some View {
        let viewModel = GeneratePhraseViewModel(coordinator: coordinator)
        let view = GeneratePhraseView(viewModel: viewModel)
        return view
    }
}
