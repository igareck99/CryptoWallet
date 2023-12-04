import SwiftUI

enum AdminsViewAssembly {
    static func build(
        chatData: Binding<ChatData>,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) -> some View {
        let viewModel = AdminsViewModel(
            chatData: chatData,
            coordinator: coordinator
        )
        let view = AdminsView(viewModel: viewModel)
        return view
    }
}
