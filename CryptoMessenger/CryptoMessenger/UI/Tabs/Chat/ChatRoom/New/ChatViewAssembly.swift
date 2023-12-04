import SwiftUI

enum ChatViewAssembly {
    static func build(
        room: AuraRoomData,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) -> some View {
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
