import UIKit

typealias AppCoordinatable = Coordinator & AppCoordinatorProtocol & AppDelegateApplicationLifeCycle

enum AppCoordinatorAssembly {
	static func build(navigationController: UINavigationController) -> AppCoordinatable {

		let keychainService = KeychainService.shared
		let userSettings = UserDefaultsService.shared
        let router = AppCoordinatorRouter()
        let privateDataCleaner = PrivateDataCleaner.shared
        let timeService = AppTimeService(keychainService: keychainService)
        let coordinator = AppCoordinator(
            keychainService: keychainService,
            userSettings: userSettings,
            router: router,
            factory: CoordinatorsFactory.self,
            privateDataCleaner: privateDataCleaner,
            timeService: timeService,
            navigationController: navigationController
        )
		return coordinator
	}
}
