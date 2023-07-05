import Foundation
import SwiftUI

// MARK: - ChatHistoryAssembly

enum ChatHistoryAssembly {
    static func build() -> some View {
        let viewModel = ChatHistoryViewModel()
        var view = ChatHistoryView(viewModel: viewModel)
        let router = ChatHistoryRouter {
            view
        }
        let coordinator = ChatHistoryFlowCoordinator(router: router)
        viewModel.coordinator = coordinator
        return router
    }
}
