import SwiftUI

// MARK: - ChatRoomAssembly

enum ChatRoomAssembly {

    // MARK: - Static Methods

    static func build(
		room: AuraRoom,
		coordinator: ChatHistoryFlowCoordinatorProtocol?
	) -> some View {
		let groupCallsUseCase = GroupCallsUseCase(room: room.room)
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
