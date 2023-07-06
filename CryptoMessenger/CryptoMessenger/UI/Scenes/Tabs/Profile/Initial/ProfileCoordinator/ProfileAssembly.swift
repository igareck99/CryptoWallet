import SwiftUI

// MARK: - ProfileAssembly

enum ProfileAssembly {

    // MARK: - Static Methods

    static func build(_ delegate: ProfileSceneDelegate) -> some View {
        let userSettings = UserDefaultsService.shared
        let keychainService = KeychainService.shared
        let viewModel = ProfileViewModel(
            userSettings: userSettings,
            keychainService: keychainService
        )
        let coordinator = ProfileFlowCoordinator(router: delegate)
        viewModel.coordinator = coordinator
        let view = ProfileView(viewModel: viewModel)
        return view
    }
}
