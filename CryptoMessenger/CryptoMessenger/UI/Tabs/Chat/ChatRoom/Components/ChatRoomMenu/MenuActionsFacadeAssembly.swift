import Foundation

// MARK: - MenuActionsFacadeAssembly

enum MenuActionsFacadeAssembly {

    // MARK: - Static Methods

    static func build() -> MenuActionsTogglesFacadeProtocol {
        let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
        let availabilityFacade = MenuActionsTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
        return availabilityFacade
    }
}
