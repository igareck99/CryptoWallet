import SwiftUI

enum SelectContactAssembly {
    static func build(
        mode: ContactViewMode,
        chatData: Binding<ChatData> = .constant(.init()),
        contactsLimit: Int? = nil,
        coordinator: ChatCreateFlowCoordinatorProtocol? = nil,
        chatHistoryCoordinator: ChatsCoordinatable? = nil,
        channelParticipantsCoordinator: ChannelParticipantsFlowCoordinatorProtocol? = nil,
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
        viewModel.channelParticipantsCoordinator = channelParticipantsCoordinator
        let view = SelectContactView(viewModel: viewModel)
        return view
    }
}
