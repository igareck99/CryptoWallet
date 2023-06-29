import UIKit

enum AuthCoordinatorAssembly {
    static func build(
        delegate: AuthCoordinatorDelegate,
        navigationController: UINavigationController
    ) -> Coordinator {
        let userFlows = UserDefaultsService.shared
        let router = AuhtRouter(navigationController: navigationController)
        let coordinator = AuthCoordinator(
            router: router,
            userFlows: userFlows,
            navigationController: navigationController
        )
        coordinator.delegate = delegate
        return coordinator
    }
}
