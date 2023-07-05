import Foundation
import SwiftUI

// MARK: - ChatCreateAssembly

enum ChatCreateAssembly {
    static func build(_ chatData: Binding<ChatData>,
                      onCoordinatorEnd: @escaping VoidBlock) -> some View {
        let viewModel = ChatCreateViewModel()
        let view = ChatCreateView(chatData: chatData,
                                  viewModel: viewModel)
        let router = ChatCreateRouter {
            view
        }
        let coordinator = ChatCreateFlowCoordinator(router: router, onCoordinatorEnd: {
            onCoordinatorEnd()
        })
        viewModel.coordinator = coordinator
        return router
    }
}
