import UIKit
import SwiftUI

// MARK: - MainFlowCoordinatorAssembly

enum MainFlowCoordinatorAssembly {
	static func build(
        delegate: MainFlowCoordinatorDelegate,
        navigationController: UINavigationController,
        renderView: @escaping (any View) -> Void
    ) -> Coordinator {
        let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
        let togglesFacade = MainFlowTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
		let mainFlowCoordinator = MainFlowCoordinator(
			navigationController: navigationController,
			togglesFacade: togglesFacade,
            renderView: { result in
                renderView(result)
            }
		)
		mainFlowCoordinator.delegate = delegate

		return mainFlowCoordinator
	}
}
