import UIKit

// MARK: - AppDelegateUseCaseAssembly

enum AppDelegateUseCaseAssembly {
	static func build(appCoordinator: Coordinator & AppCoordinatorProtocol) -> AppDelegateUseCaseProtocol {
		let appUseCase = AppDelegateUseCase(
			appCoordinator: appCoordinator,
            keychainService: KeychainService.shared,
            privateDataCleaner: PrivateDataCleaner.shared,
			userSettings: UserDefaultsService.shared,
			timeService: TimeService.self
		)
		return appUseCase
	}
}
