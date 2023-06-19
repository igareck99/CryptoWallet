import Foundation

// MARK: - ChatRoomViewModelAssembly

enum ChatRoomViewModelAssembly {

    // MARK: - Static Methods

	static func build() -> ChatRoomTogglesFacadeProtocol {
		let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
		let availabilityFacade = ChatRoomTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
		return availabilityFacade
	}
}

enum ChatRoomViewModelAssembl {

    // MARK: - Static Methods

    static func build(_ room: AuraRoom) -> ChatRoomView {
        let groupCallsUseCase = GroupCallsUseCase(room: room.room)
        let toggleFacade: MainFlowTogglesFacadeProtocol = MainFlowTogglesFacade.shared
        let viewModel = ChatRoomViewModel(
            room: room,
            toggleFacade: toggleFacade,
            groupCallsUseCase: groupCallsUseCase
        )
        return ChatRoomView(viewModel: viewModel)
    }
}


