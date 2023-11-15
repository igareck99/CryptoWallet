import SwiftUI

// MARK: - FriendProfileAssembly

enum FriendProfileAssembly {

    // MARK: - Static Methods

    static func build(userId: String,
                      roomId: String,
                      coordinator: ChatHistoryFlowCoordinatorProtocol) -> some View {
        let keychainService = KeychainService.shared
        let viewModel = FriendProfileViewModel(
            userId: userId,
            roomId: roomId,
            chatHistoryCoordinator: coordinator,
            keychainService: keychainService
        )
        let view = FriendProfileView(viewModel: viewModel)
        return view
    }
}
