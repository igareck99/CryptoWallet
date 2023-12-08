import SwiftUI

typealias ProfileCoordinatorType = ProfileCoordinator<ProfileRouter<ProfileView<ProfileViewModel>,ProfileRouterState,ViewsBaseFactory>>

enum ProfileAssembly {

    static weak var coordinator: ProfileCoordinatorType?

    static func build(onlogout: @escaping VoidBlock) -> some View {
        let userSettings = UserDefaultsService.shared
        let keychainService = KeychainService.shared
        let viewModel = ProfileViewModel(
            userSettings: userSettings,
            keychainService: keychainService
        )
        let view = ProfileView(viewModel: viewModel)
        let router = ProfileRouter(
            state: ProfileRouterState.shared,
            factory: ViewsBaseFactory.self
        ) {
            view
        }
        let coordinator = ProfileCoordinator(
            router: router,
            onlogout: onlogout
        )
        viewModel.coordinator = coordinator
        Self.coordinator = coordinator
        return router
    }
}
