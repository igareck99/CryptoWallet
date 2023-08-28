import SwiftUI

// MARK: - SelectContactAssembly

enum SelectContactAssembly {
    static func build(
        mode: ContactViewMode,
        chatData: Binding<ChatData> = .constant(.init()),
        contactsLimit: Int? = nil,
        coordinator: ChatCreateFlowCoordinatorProtocol? = nil,
        onSelectContact: GenericBlock<[Contact]>? = nil
    ) -> some View {
        let viewModel = SelectContactViewModel(mode: mode, contactsLimit: contactsLimit,
                                               onSelectContact: onSelectContact)
        viewModel.coordinator = coordinator
        let view = SelectContactView(
            viewModel: viewModel
        )
        return view
    }
}
