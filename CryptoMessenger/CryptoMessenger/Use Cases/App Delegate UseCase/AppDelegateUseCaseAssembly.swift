import UIKit

enum AppDelegateUseCaseAssembly {
	static func build(appCoordinator: Coordinator & AppCoordinatorProtocol) -> AppDelegateUseCaseProtocol {
		let appUseCase = AppDelegateUseCase(
			appCoordinator: appCoordinator,
			keychainService: KeychainService.shared,
			userSettings: UserDefaultsService.shared,
			timeService: TimeService.self
		)
		return appUseCase
	}
}
