import UIKit

enum RemoteConfigUseCaseAssembly {
    static func build(appCoordinator: Coordinator & AppCoordinatorProtocol) -> MainFlowTogglesFacadeProtocol {
        let remoteConfigFactory = RemoteConfigFactory()
        let remoteConfigService = FirebaseRemoteConfigService(remoteConfigFactory: remoteConfigFactory)
        let remoteConfigUseCase = RemoteConfigUseCase(firebaseService: remoteConfigService)
        let togglesFacade = MainFlowTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
        return togglesFacade
    }
}
