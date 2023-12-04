import Foundation

enum MenuActionsFacadeAssembly {
    static func build() -> MenuActionsTogglesFacadeProtocol {
        let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
        let availabilityFacade = MenuActionsTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
        return availabilityFacade
    }
}
