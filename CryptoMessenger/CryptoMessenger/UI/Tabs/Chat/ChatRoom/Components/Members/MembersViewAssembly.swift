import SwiftUI

// MARK: - MembersViewAssembly

enum MembersViewAssembly {
    
    static func build(chatData: Binding<ChatData>,
                      coordinator: ChatHistoryFlowCoordinatorProtocol) -> some View {
        let viewModel = MembersViewModel(chatData: chatData,
                                        coordinator: coordinator)
        let view = MembersView(viewModel: viewModel)
        return view
    }
}
