import Foundation
import SwiftUI

typealias ChatsCoordinatorType = ChatsCoordinator<ChatsRouter<ChatHistoryView<ChatHistoryViewModel>,ChatsRouterState, ViewsBaseFactory>>

enum ChatsViewAssemlby {

    static weak var coordinator: ChatsCoordinatorType?

    static func build() -> some View {
        let viewModel = ChatHistoryViewModel()
        let view = ChatHistoryView(viewModel: viewModel)
        let state = ChatsRouterState.shared
        let router = ChatsRouter(
            state: state,
            factory: ViewsBaseFactory.self
        ) {
            view
        }
        let coordinator = ChatsCoordinator(router: router)
        viewModel.coordinator = coordinator
        Self.coordinator = coordinator
        return router
    }
}
