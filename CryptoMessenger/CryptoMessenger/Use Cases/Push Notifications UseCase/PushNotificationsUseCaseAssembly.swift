import Foundation

enum PushNotificationsUseCaseAssembly {
	static func build(appCoordinator: AppCoordinatorProtocol) -> PushNotificationsUseCaseProtocol {
		let keychainService = KeychainService.shared
		let pushNotificationsService = PushNotificationsService()
		let userFlowsStorage = UserDefaultsService.shared
		let matrixUseCase = MatrixUseCase.shared
		let pushNotificationsUseCase = PushNotificationsUseCase(
			appCoordinator: appCoordinator,
			userSettings: userFlowsStorage,
			keychainService: keychainService,
			pushNotificationsService: pushNotificationsService,
			matrixUseCase: matrixUseCase
		)
		return pushNotificationsUseCase
	}
}
