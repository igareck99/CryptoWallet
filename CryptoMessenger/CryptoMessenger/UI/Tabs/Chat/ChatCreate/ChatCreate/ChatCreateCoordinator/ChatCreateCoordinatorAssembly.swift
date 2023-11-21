import SwiftUI

// MARK: - ChatCreateCoordinatorAssembly

enum ChatCreateCoordinatorAssembly {
    static func buld(
        onCoordinatorEnd: @escaping (Coordinator) -> Void,
        onFriendProfile: @escaping (AuraRoomData) -> Void
    ) -> Coordinator {
        let state = ChatCreateFlowState.shared
        let viewModel = ChatCreateViewModel()
        let view = ChatCreateView(viewModel: viewModel)
        let router = ChatCreateRouter(state: state) {
            view
        }
        let coordinator = ChatCreateFlowCoordinator(
            router: router,
            onCoordinatorEnd: onCoordinatorEnd,
            onFriendProfile: onFriendProfile
        )
        viewModel.coordinator = coordinator
        return coordinator
    }
}
