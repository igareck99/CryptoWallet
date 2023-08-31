import SwiftUI

// MARK: - ChatViewAssembly

enum ChatViewAssembly {

    // MARK: - Static Methods

    static func build(_ room: AuraRoomData,
                      _ coordinator: ChatHistoryFlowCoordinatorProtocol) -> some View {
        let viewModel = ChatViewModel(room: room,
                                      coordinator: coordinator)
        let view = ChatView(viewModel: viewModel)
        return view
    }
}
