import SwiftUI

// MARK: - NotificationSettingsAssembly

enum NotificationSettingsAssembly {

    // MARK: - Static Methods

    static func build(_ coordinator: ProfileFlowCoordinatorProtocol)
                                -> some View {
        let userSettings = UserDefaultsService.shared
        let viewModel = NotificationSettingsViewModel(userSettings: userSettings)
        viewModel.coordinator = coordinator
        let view = NotificationSettingsView(viewModel: viewModel)
        return view
    }
}