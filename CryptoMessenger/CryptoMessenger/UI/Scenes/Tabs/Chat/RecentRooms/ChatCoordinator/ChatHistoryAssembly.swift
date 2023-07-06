import Foundation
import SwiftUI

// MARK: - ChatHistoryAssembly

enum ChatHistoryAssembly {

    static func build() -> some View {
        let viewModel = ChatHistoryViewModel()
        var view = ChatHistoryView(viewModel: viewModel)
        let state = ChatHistoryFlowState()
        let router = ChatHistoryRouter(state: state) {
            view
        }

        let coordinator = ChatHistoryFlowCoordinator(router: router, state: state)
        viewModel.coordinator = coordinator
        return router
    }

    // Оставил на всякий случай после конфликтов мерджа
//    static func build(_ delegate: ChatHistorySceneDelegate) -> some View {
//        let viewModel = ChatHistoryViewModel()
//        var view = ChatHistoryView(viewModel: viewModel)
//        let coordinator = ChatHistoryFlowCoordinator(router: delegate)
//        viewModel.coordinator = coordinator
//        return view
//    }
}
