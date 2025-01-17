import Foundation

// MARK: - ChatRoomConfigurator

enum ChatRoomConfigurator {

    // MARK: - Static Methods

    static func configuredView(
		room: AuraRoom,
		delegate: ChatRoomSceneDelegate?,
		toggleFacade: MainFlowTogglesFacadeProtocol
	) -> ChatRoomView {
		let groupCallsUseCase = GroupCallsUseCase(room: room.room)
		let viewModel = ChatRoomViewModel(
			room: room,
			toggleFacade: toggleFacade,
			groupCallsUseCase: groupCallsUseCase
		)
        viewModel.delegate = delegate
        return ChatRoomView(viewModel: viewModel)
    }
}
