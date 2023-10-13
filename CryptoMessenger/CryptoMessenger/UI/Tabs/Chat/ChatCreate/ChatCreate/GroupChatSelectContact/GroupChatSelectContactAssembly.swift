import SwiftUI

// MARK: - SelectContactAssembly

enum GroupChatSelectContactAssembly {
    static func build(
        coordinator: ChatCreateFlowCoordinatorProtocol?
    ) -> some View {
        let viewModel = GroupChatSelectContactViewModel(coordinator: coordinator)
        let view = GroupChatSelectContactView(viewModel: viewModel)
        return view
    }
}
