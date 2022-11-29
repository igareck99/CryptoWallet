import Foundation

// MARK: - NotificationSettingsConfigurator

enum NotificationSettingsConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: NotificationSettingsSceneDelegate?)
                                -> NotificationSettingsView {
        let userSettings = UserDefaultsService.shared
        let viewModel = NotificationSettingsViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = NotificationSettingsView(viewModel: viewModel)
        return view
    }
}
