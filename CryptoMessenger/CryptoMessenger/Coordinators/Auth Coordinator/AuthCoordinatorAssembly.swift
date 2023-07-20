import UIKit

enum AuthCoordinatorAssembly {
    static func build(
        delegate: AuthCoordinatorDelegate,
        navigationController: UINavigationController,
        renderView: @escaping (Coordinator) -> Void
    ) -> Coordinator {
        let userFlows = UserDefaultsService.shared
        let router = AuhtRouter(navigationController: navigationController)
        let coordinator = AuthCoordinator(
            router: router,
            userFlows: userFlows,
            navigationController: navigationController, renderView: { result in
                renderView(result)
            }
        )
        coordinator.delegate = delegate
        return coordinator
    }
}
