import UIKit
import SwiftUI

// MARK: - MainFlowCoordinatorAssembly

enum MainFlowCoordinatorAssembly {
	static func build(
        delegate: MainFlowCoordinatorDelegate,
        renderView: @escaping RootViewBuilder,
        onlogout: @escaping () -> Void
    ) -> Coordinator {
        let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
        let togglesFacade = MainFlowTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
		let mainFlowCoordinator = MainFlowCoordinator(
			togglesFacade: togglesFacade,
            renderView: renderView,
            onlogout: onlogout
		)
		mainFlowCoordinator.delegate = delegate
		return mainFlowCoordinator
	}
}
