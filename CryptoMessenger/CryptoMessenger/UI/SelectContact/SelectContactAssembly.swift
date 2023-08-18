import SwiftUI

// MARK: - SelectContactAssembly

enum SelectContactAssembly {
    static func build(
        mode: ContactViewMode,
        chatData: Binding<ChatData>,
        contactsLimit: Int? = nil,
        coordinator: ChatCreateFlowCoordinatorProtocol? = nil,
        onSelectContact: GenericBlock<[Contact]>? = nil
    ) -> some View {
        let viewModel = SelectContactViewModel(mode: mode)
        viewModel.coordinator = coordinator
        let view = SelectContactView(
            viewModel: viewModel,
            chatData: chatData,
            contactsLimit: contactsLimit,
            onSelectContact: onSelectContact
        )
        return view
    }
}
