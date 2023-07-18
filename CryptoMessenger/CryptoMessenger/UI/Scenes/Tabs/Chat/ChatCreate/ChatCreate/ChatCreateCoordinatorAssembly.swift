import SwiftUI

// MARK: - ChatCreateCoordinatorAssembly

enum ChatCreateCoordinatorAssembly {
    static func buld(
        path: Binding<NavigationPath>,
        presentedItem: Binding<ChatHistorySheetLink?>,
        chatData: Binding<ChatData>,
        onCoordinatorEnd: @escaping (Coordinator) -> Void
    ) -> Coordinator {
        let state = ChatCreateFlowState(path: path,
                                        presentedItem: presentedItem)
        let router = ChatCreateRouter(state: state)
        let coordinator = ChatCreateFlowCoordinator(router: router,
                                                    chatData: chatData,
                                                    onCoordinatorEnd: onCoordinatorEnd)
        return coordinator
    }
}
