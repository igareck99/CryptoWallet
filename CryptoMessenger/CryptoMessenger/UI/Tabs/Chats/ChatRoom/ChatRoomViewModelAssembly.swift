import Foundation
import SwiftUI

enum ChatRoomViewModelAssembly {
	static func build() -> ChatRoomTogglesFacadeProtocol {
		let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
		let availabilityFacade = ChatRoomTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
		return availabilityFacade
	}

    static func make(room: AuraRoom) -> some View {
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
