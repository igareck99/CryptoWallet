import Foundation
import SwiftUI

// MARK: - ChatHistoryAssembly

enum ChatHistoryAssembly {
    static func build(_ delegate: ChatHistorySceneDelegate) -> some View {
        let viewModel = ChatHistoryViewModel()
        var view = ChatHistoryView(viewModel: viewModel)
        let router = ChatHistoryRouter(content: view.content)
        view.routableContent = AnyView(router)
        let coordinator = ChatHistoryFlowCoordinator(router: delegate)
        viewModel.coordinator = coordinator
        return view
    }
}
