import Foundation

enum NotificationsUseCaseAssembly {
	static func build(appCoordinator: AppCoordinatorProtocol) -> NotificationsUseCaseProtocol {
		let keychainService = KeychainService.shared
		let pushNotificationsService = PushNotificationsService()
        var pushKitService: PushKitServiceProtocol = makePushKitService()
		let userFlowsStorage = UserDefaultsService.shared
		let matrixUseCase = MatrixUseCase.shared
		let notificationsUseCase = NotificationsUseCase(
			appCoordinator: appCoordinator,
			userSettings: userFlowsStorage,
			keychainService: keychainService,
			pushNotificationsService: pushNotificationsService,
            pushKitService: pushKitService,
			matrixUseCase: matrixUseCase,
            togglesFacade: RemoteConfigUseCaseAssembly.useCase
		)
        pushKitService.delegate = notificationsUseCase
		return notificationsUseCase
	}
    
    static func makePushKitService() -> PushKitServiceProtocol {
        
        let shouldUseMock = RemoteConfigUseCaseAssembly.useCase.isVoipPushServiceMockAvailable
        if shouldUseMock {
            return PushKitServiceMock()
        }
        
        let isVoipPusherShouldIgnored = RemoteConfigUseCaseAssembly.useCase.isVoipPusherShouldIgnored
        
        UserDefaultsService.shared[.isVoipPusherCreated] = !isVoipPusherShouldIgnored
                
        let isVoipPusherCreated: Bool = UserDefaultsService.shared[.isVoipPusherCreated] == true
        var pushKitService: PushKitServiceProtocol
        
        if isVoipPusherCreated {
            pushKitService = PushKitServiceMock()
        } else {
            pushKitService = PushKitService()
        }
        
        return pushKitService
    }
}
