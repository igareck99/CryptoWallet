import SwiftUI

// MARK: - ChatCreateCoordinatorAssembly

enum ChatCreateCoordinatorAssembly {
    static func buld(
        chatData: Binding<ChatData>,
        onCoordinatorEnd: @escaping (Coordinator) -> Void
    ) -> Coordinator {
        let state = ChatCreateFlowState.shared
        let viewModel = ChatCreateViewModel()
        let view = ChatCreateView(chatData: chatData,
                                  viewModel: viewModel)
        let router = ChatCreateRouter(state: state) {
            view
        }
        let coordinator = ChatCreateFlowCoordinator(router: router,
                                                    chatData: chatData,
                                                    onCoordinatorEnd: onCoordinatorEnd)
        viewModel.coordinator = coordinator
        return coordinator
    }
}
