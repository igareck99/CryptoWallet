import SwiftUI

// MARK: - FriendProfileAssembly

enum FriendProfileAssembly {

    // MARK: - Static Methods

    static func build(userId: Contact) -> some View {
        let userSettings = UserDefaultsService.shared
        let keychainService = KeychainService.shared
        let viewModel = FriendProfileViewModel(
            userId: userId,
            userSettings: userSettings,
            keychainService: keychainService
        )
        let view = FriendProfileView(viewModel: viewModel)
        return view
    }
}
