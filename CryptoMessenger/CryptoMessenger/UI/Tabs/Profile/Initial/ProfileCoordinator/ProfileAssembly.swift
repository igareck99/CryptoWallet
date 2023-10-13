import SwiftUI

// MARK: - ProfileAssembly

enum ProfileAssembly {

    // MARK: - Static Methods

    static func build(
        onlogout: @escaping () -> Void
    ) -> some View {
        let userSettings = UserDefaultsService.shared
        let keychainService = KeychainService.shared
        let viewModel = ProfileViewModel(
            userSettings: userSettings,
            keychainService: keychainService
        )
        let view = ProfileView(viewModel: viewModel)
        let router = ProfileRouter(state: ProfileFlowState()) {
            view
        }
        let coordinator = ProfileFlowCoordinator(
            router: router,
            onlogout: onlogout
        )
        viewModel.coordinator = coordinator
        return router
    }
}
