import SwiftUI

enum NotificationSettingsAssembly {
    static func build(
        _ coordinator: ProfileCoordinatable
    ) -> some View {
        let userSettings = UserDefaultsService.shared
        let viewModel = NotificationSettingsViewModel(userSettings: userSettings)
        viewModel.coordinator = coordinator
        let view = NotificationSettingsView(viewModel: viewModel)
        return view
    }
}
