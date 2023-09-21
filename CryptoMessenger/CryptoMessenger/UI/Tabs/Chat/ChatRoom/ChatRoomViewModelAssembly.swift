import Foundation
import SwiftUI

// MARK: - ChatRoomViewModelAssembly

enum ChatRoomViewModelAssembly {

    // MARK: - Static Methods

	static func build() -> ChatRoomTogglesFacadeProtocol {
		let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
		let availabilityFacade = ChatRoomTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
		return availabilityFacade
	}

    static func make(_ room: AuraRoom) -> some View {
        let groupCallsUseCase = GroupCallsUseCase(roomId: room.room.roomId)
        let toggleFacade: MainFlowTogglesFacadeProtocol = MainFlowTogglesFacade.shared
        let viewModel = ChatRoomViewModel(
            room: room,
            toggleFacade: toggleFacade,
            groupCallsUseCase: groupCallsUseCase
        )
        return ChatRoomView(viewModel: viewModel)
    }
}
