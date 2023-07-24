import SwiftUI

// MARK: - ProfileAssembly

enum ProfileAssembly {

    // MARK: - Static Methods

    static func build() -> some View {
        let userSettings = UserDefaultsService.shared
        let keychainService = KeychainService.shared
        let viewModel = ProfileViewModel(
            userSettings: userSettings,
            keychainService: keychainService
        )
        let view = ProfileView(viewModel: viewModel)
        let router = ProfileRouter(state: ProfileFlowState.shared) {
            view
        }
        let coordinator = ProfileFlowCoordinator(router: router)
        viewModel.coordinator = coordinator
        return router
    }
}
