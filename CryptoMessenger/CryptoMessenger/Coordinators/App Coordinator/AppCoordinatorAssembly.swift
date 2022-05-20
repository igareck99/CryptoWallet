import UIKit

enum AppCoordinatorAssembly {
	static func build(navigationController: UINavigationController) -> Coordinator & AppCoordinatorProtocol {

		let keychainService = KeychainService.shared
		let userFlows = UserDefaultsService.shared
		let coordinator = AppCoordinator(
			keychainService: keychainService,
			userFlows: userFlows,
			navigationController: navigationController
		)
		return coordinator
	}
}
