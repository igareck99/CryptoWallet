import SwiftUI

enum ChatRoomAssembly {
    static func build(
		room: AuraRoom,
		coordinator: ChatsCoordinatable?
	) -> some View {
        let groupCallsUseCase = GroupCallsUseCase(roomId: room.room.roomId)
        let facade = MainFlowTogglesFacade()
		let viewModel = ChatRoomViewModel(
			room: room,
			toggleFacade: facade,
			groupCallsUseCase: groupCallsUseCase
		)
        viewModel.coordinator = coordinator
        return ChatRoomView(viewModel: viewModel)
    }
}
