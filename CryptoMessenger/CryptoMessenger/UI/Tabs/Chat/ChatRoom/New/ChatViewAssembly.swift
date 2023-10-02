import SwiftUI

// MARK: - ChatViewAssembly

enum ChatViewAssembly {

    // MARK: - Static Methods

    static func build(_ room: AuraRoomData,
                      _ coordinator: ChatHistoryFlowCoordinatorProtocol) -> some View {
        let groupCallsUseCase = GroupCallsUseCase(roomId: room.roomId)
        let viewModel = ChatViewModel(
            room: room,
            coordinator: coordinator,
            groupCallsUseCase: groupCallsUseCase
        )
        let view = ChatView(viewModel: viewModel)
        return view
    }
}
