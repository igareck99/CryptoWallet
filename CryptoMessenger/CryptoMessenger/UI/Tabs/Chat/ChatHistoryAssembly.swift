import Foundation
import SwiftUI

enum ChatHistoryAssembly {

    static func build() -> some View {
        let viewModel = ChatHistoryViewModel()
        let view = ChatHistoryView(viewModel: viewModel)
        let state = ChatHistoryFlowState.shared
        let router = ChatHistoryRouter(
            state: state,
            factory: ViewsBaseFactory.self
        ) {
            view
        }

        let coordinator = ChatHistoryFlowCoordinator(router: router)
        viewModel.coordinator = coordinator
        return router
    }
}
