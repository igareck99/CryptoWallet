import SwiftUI

enum SelectContactAssembly {
    static func build(
        mode: ContactViewMode,
        chatData: Binding<ChatData> = .constant(.init()),
        contactsLimit: Int? = nil,
        coordinator: ChatCreateFlowCoordinatorProtocol? = nil,
        chatHistoryCoordinator: ChatHistoryFlowCoordinatorProtocol? = nil,
        onUsersSelected: @escaping ([Contact]) -> Void
    ) -> some View {
        let viewModel = SelectContactViewModel(
            mode: mode,
            contactsLimit: contactsLimit
        ) { value in
            onUsersSelected(value)
        }
        viewModel.coordinator = coordinator
        viewModel.chatHistoryCoordinator = chatHistoryCoordinator
        let view = SelectContactView(viewModel: viewModel)
        return view
    }
}
