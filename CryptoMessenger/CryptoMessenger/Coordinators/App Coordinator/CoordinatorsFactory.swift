import UIKit
import SwiftUI

protocol CoordinatorsFactoryProtocol {
    static func makePinCoordinator(
        delegate: PinCodeFlowCoordinatorDelegate,
        navigationController: UINavigationController,
        renderView: @escaping RootViewBuilder,
        onLogin: @escaping () -> Void
    ) -> Coordinator

    static func makeAuthCoordinator(
        delegate: AuthCoordinatorDelegate,
        renderView: @escaping RootViewBuilder
    ) -> Coordinator

    static func makeMainCoordinator(
        delegate: MainFlowCoordinatorDelegate,
        renderView: @escaping RootViewBuilder,
        onlogout: @escaping () -> Void
    ) -> Coordinator

    static func makePushCoordinator(
        notification: UNNotificationResponse,
        delegate: PushNotificationCoordinatorDelegate,
        navigationController: UINavigationController
    ) -> Coordinator
}

enum CoordinatorsFactory: CoordinatorsFactoryProtocol {

    static func makePinCoordinator(
        delegate: PinCodeFlowCoordinatorDelegate,
        navigationController: UINavigationController,
        renderView: @escaping RootViewBuilder,
        onLogin: @escaping () -> Void
    ) -> Coordinator {
        let userFlows = UserDefaultsService.shared
        let coordinator = PinCodeFlowCoordinator(
            userFlows: userFlows,
            navigationController: navigationController,
            renderView: { result in
                renderView(result)
            }, onLogin: {
                onLogin()
            }
        )
        coordinator.delegate = delegate
        return coordinator
    }

    static func makeAuthCoordinator(
        delegate: AuthCoordinatorDelegate,
        renderView: @escaping RootViewBuilder
    ) -> Coordinator {
        AuthCoordinatorAssembly.build(
            delegate: delegate,
            renderView: renderView
        )
    }

    static func makeMainCoordinator(
        delegate: MainFlowCoordinatorDelegate,
        renderView: @escaping RootViewBuilder,
        onlogout: @escaping () -> Void
    ) -> Coordinator {
        let coordinator = MainFlowCoordinatorAssembly.build(
            delegate: delegate,
            renderView: renderView,
            onlogout: onlogout
        )
        return coordinator
    }

    static func makePushCoordinator(
        notification: UNNotificationResponse,
        delegate: PushNotificationCoordinatorDelegate,
        navigationController: UINavigationController) -> Coordinator {
        let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
        let togglesFacade = MainFlowTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
        let coordinator = PushNotificationCoordinatorAssembly.build(
            notificationResponse: notification,
            navigationController: navigationController,
            delegate: delegate,
            toggleFacade: togglesFacade
        )
        return coordinator
    }
}
