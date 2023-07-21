import UIKit
import SwiftUI

protocol CoordinatorsFactoryProtocol {
    static func makePinCoordinator(
        delegate: PinCodeFlowCoordinatorDelegate,
        navigationController: UINavigationController,
        renderView: @escaping (any View) -> Void,
        onLogin: @escaping () -> Void
    ) -> Coordinator

    static func makeAuthCoordinator(
        delegate: AuthCoordinatorDelegate,
        navigationController: UINavigationController,
        renderView: @escaping (Coordinator) -> Void
    ) -> Coordinator

    static func makeMainCoordinator(
        delegate: MainFlowCoordinatorDelegate,
        navigationController: UINavigationController,
        renderView: @escaping (any View) -> Void
    ) -> Coordinator

    static func makePushCoordinator(
        notification: UNNotificationResponse,
        delegate: PushNotificationCoordinatorDelegate,
        navigationController: UINavigationController,
        getChatRoomSceneDelegate: @escaping () -> ChatRoomSceneDelegate?
    ) -> Coordinator
}

enum CoordinatorsFactory: CoordinatorsFactoryProtocol {

    static func makePinCoordinator(
        delegate: PinCodeFlowCoordinatorDelegate,
        navigationController: UINavigationController,
        renderView: @escaping (any View) -> Void,
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
        navigationController: UINavigationController,
        renderView: @escaping (Coordinator) -> Void
    ) -> Coordinator {
        AuthCoordinatorAssembly.build(
            delegate: delegate,
            navigationController: navigationController, renderView: { result in
                renderView(result)
            }
        )
    }

    static func makeMainCoordinator(
        delegate: MainFlowCoordinatorDelegate,
        navigationController: UINavigationController,
        renderView: @escaping (any View) -> Void
    ) -> Coordinator {
        let coordinator = MainFlowCoordinatorAssembly.build(
            delegate: delegate,
            navigationController: navigationController,
            renderView: { result in
                renderView(result)
            }
        )
        return coordinator
    }

    static func makePushCoordinator(
        notification: UNNotificationResponse,
        delegate: PushNotificationCoordinatorDelegate,
        navigationController: UINavigationController,
        getChatRoomSceneDelegate: @escaping () -> ChatRoomSceneDelegate?
    ) -> Coordinator {
        let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
        let togglesFacade = MainFlowTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
        let coordinator = PushNotificationCoordinatorAssembly.build(
            getChatRoomSceneDelegate: getChatRoomSceneDelegate,
            notificationResponse: notification,
            navigationController: navigationController,
            delegate: delegate,
            toggleFacade: togglesFacade
        )
        return coordinator
    }
}
