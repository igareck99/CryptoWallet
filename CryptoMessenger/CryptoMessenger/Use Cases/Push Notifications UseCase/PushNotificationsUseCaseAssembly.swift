import Foundation

enum PushNotificationsUseCaseAssembly {
	static func build(appCoordinator: AppCoordinatorProtocol) -> PushNotificationsUseCaseProtocol {
		let keychainService = KeychainService.shared
		let pushNotificationsService = PushNotificationsService()
		let userFlowsStorage = UserDefaultsService.shared
		let pushNotificationsUseCase = PushNotificationsUseCase(
			appCoordinator: appCoordinator,
			userSettings: userFlowsStorage,
			keychainService: keychainService,
			pushNotificationsService: pushNotificationsService,
			matrixStore: MatrixStore.shared
		)
		return pushNotificationsUseCase
	}
}
