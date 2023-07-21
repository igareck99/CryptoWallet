import Foundation
import SwiftUI

// MARK: - ChatHistoryAssembly

enum ChatHistoryAssembly {

    static func build() -> some View {
        let viewModel = ChatHistoryViewModel()
        let view = ChatHistoryView(viewModel: viewModel)
        let router = ChatHistoryRouter(state: ChatHistoryFlowState.shared) {
            view
        }

        let coordinator = ChatHistoryFlowCoordinator(router: router)
        viewModel.coordinator = coordinator
        return router
    }
}
