import UIKit

// MARK: - MainFlowCoordinatorAssembly

enum MainFlowCoordinatorAssembly {
	static func build(
		delegate: MainFlowCoordinatorDelegate,
		navigationController: UINavigationController
	) -> Coordinator {
		let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
		let togglesFacade = MainFlowTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
		let mainFlowCoordinator = MainFlowCoordinator(
			navigationController: navigationController,
			togglesFacade: togglesFacade
		)
		mainFlowCoordinator.delegate = delegate

		return mainFlowCoordinator
	}
}
