import SwiftUI

enum AuthCoordinatorAssembly {
    static func build(
        delegate: AuthCoordinatorDelegate,
        renderView: @escaping (any View) -> Void
    ) -> Coordinator {
        let userFlows = UserDefaultsService.shared
        let sources = OnboardingResources.self
        let viewModel = OnboardingViewModel(
            sources: sources,
            userFlows: userFlows
        )
        let view = OnboardingView(viewModel: viewModel)
        let state = AuthState.shared
        let router = AuhtRouter(state: state) {
            view
        }
        let coordinator = AuthCoordinator(
            router: router,
            userFlows: userFlows,
            renderView: renderView
        )
        coordinator.delegate = delegate
        viewModel.delegate = coordinator
        return coordinator
    }
}
