import SwiftUI

enum FriendProfileAssembly {
    static func build(
        userId: String,
        roomId: String,
        coordinator: ChatsCoordinatable
    ) -> some View {
        let viewModel = FriendProfileViewModel(
            userId: userId,
            roomId: roomId,
            chatHistoryCoordinator: coordinator
        )
        let view = FriendProfileView(viewModel: viewModel)
        return view
    }
}
