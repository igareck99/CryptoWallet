import SwiftUI

enum ChatViewAssembly {
    static func build(
        room: AuraRoomData,
        openState: RoomOpenState,
        coordinator: ChatsCoordinatable
    ) -> some View {
        let groupCallsUseCase = GroupCallsUseCase(roomId: room.roomId)
        let viewModel = ChatViewModel(
            room: room, openRoomState: openState,
            coordinator: coordinator,
            groupCallsUseCase: groupCallsUseCase
        )
        let view = ChatView(viewModel: viewModel)
        return view
    }
}
