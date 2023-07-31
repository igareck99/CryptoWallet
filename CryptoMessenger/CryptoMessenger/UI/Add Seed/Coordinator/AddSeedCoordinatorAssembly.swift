import SwiftUI

enum AddSeedCoordinatorAssembly {
    static func build<ParentState: WalletRouterStatable>(
        state: ParentState,
        onFinish: @escaping (Coordinator) -> Void
    ) -> Coordinator {

        let viewModel = AddSeedViewModel()
        let view = AddSeedView(viewModel: viewModel)

        let router = AddSeedRouter(
            state: AddSeedState.shared,
            parentState: state
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

    static func make<ParentState: WalletRouterStatable>(
        state: ParentState,
        onFinish: @escaping (Coordinator) -> Void
    ) -> Coordinator {
        let viewModel = GeneratePhraseViewModel()
        let view = GeneratePhraseView(
            viewModel: viewModel
        ) { type in
            guard type == .importKey else { return }
            viewModel.onImport()
        } onCreate: {
            viewModel.send(.onAppear)
        }

        let router = AddSeedRouter(
            state: AddSeedState.shared,
            parentState: state
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
