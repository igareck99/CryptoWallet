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
