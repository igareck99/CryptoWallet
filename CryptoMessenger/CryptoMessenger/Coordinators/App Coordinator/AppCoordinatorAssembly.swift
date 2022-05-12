import UIKit

enum AppCoordinatorAssembly {
	static func build(navigationController: UINavigationController) -> Coordinator & AppCoordinatorProtocol {

		let dependenciesService = DependenciesService()
		let firebaseService = FirebaseService()
		let keychainService = KeychainService.shared
		let userFlows = UserDefaultsService.shared
		let coordinator = AppCoordinator(
			dependenciesService: dependenciesService,
			firebaseService: firebaseService,
			keychainService: keychainService,
			userFlows: userFlows,
			navigationController: navigationController
		)
		return coordinator
	}
}
