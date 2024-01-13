import Foundation

enum ChatRoomTogglesFacadeAssembly {
    static func build() -> ChatRoomTogglesFacadeProtocol {
        let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
        let availabilityFacade = ChatRoomTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
        return availabilityFacade
    }
}
