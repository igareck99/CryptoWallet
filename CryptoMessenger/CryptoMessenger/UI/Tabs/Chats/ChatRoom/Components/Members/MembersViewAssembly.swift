import SwiftUI

enum MembersViewAssembly {
    static func build(
        chatData: Binding<ChatData>,
        coordinator: ChatsCoordinatable
    ) -> some View {
        let viewModel = MembersViewModel(
            chatData: chatData,
            coordinator: coordinator
        )
        let view = MembersView(viewModel: viewModel)
        return view
    }
}