import SwiftUI

enum AddSeedCoordinatorAssembly {

    static func make<ParentState: WalletRouterStatable>(
        state: ParentState,
        onFinish: @escaping (Coordinator) -> Void
    ) -> Coordinator {
        let viewModel = GeneratePhraseViewModel()
        let view = GeneratePhraseViewAssembly.build(
            onSelect: { type in
                guard type == .importKey else { return }
                viewModel.onImport()
            },
            onCreate: {
                viewModel.send(.onAppear)
            }
        )

        let router = AddSeedRouter(
            state: AddSeedState.shared,
            parentState: state,
            factory: ViewsBaseFactory.self
        ) {
            view
        }

        let coordinator = AddSeedCoordinator(
            router: router,
            onFinish: onFinish
        )
        viewModel.coordinator = coordinator
        return coordinator
    }
}
