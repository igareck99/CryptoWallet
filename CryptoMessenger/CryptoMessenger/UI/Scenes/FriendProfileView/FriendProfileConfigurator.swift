import Foundation

// MARK: - FriendProfileConfigurator

enum FriendProfileConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: FriendProfileSceneDelegate?,
                               userId: Contact) -> FriendProfileView {
        let userSettings = UserDefaultsService.shared
        let keychainService = KeychainService.shared
        let viewModel = FriendProfileViewModel(
            userId: userId,
            userSettings: userSettings,
            keychainService: keychainService
        )
        viewModel.delegate = delegate
        let view = FriendProfileView(viewModel: viewModel)
        return view
    }
}
