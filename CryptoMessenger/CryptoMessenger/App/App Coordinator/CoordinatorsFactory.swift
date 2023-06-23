import Foundation

protocol CoordinatorsFactoryProtocol {
    static func makePinCoordinator(
        delegate: PinCodeFlowCoordinatorDelegate,
        navigationController: UINavigationController
    ) -> Coordinator

    static func makeAuthCoordinator(
        delegate: AuthFlowCoordinatorDelegate,
        navigationController: UINavigationController
    ) -> Coordinator

    static func makeMainCoordinator(
        delegate: MainFlowCoordinatorDelegate,
        navigationController: UINavigationController
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
        navigationController: UINavigationController
    ) -> Coordinator {
        let userFlows = UserDefaultsService.shared
        let coordinator = PinCodeFlowCoordinator(
            userFlows: userFlows,
            navigationController: navigationController
        )
        coordinator.delegate = delegate
        return coordinator
    }

    static func makeAuthCoordinator(
        delegate: AuthFlowCoordinatorDelegate,
        navigationController: UINavigationController
    ) -> Coordinator {
        let userFlows = UserDefaultsService.shared
        let coordinator = AuthFlowCoordinator(
            userFlows: userFlows,
            navigationController: navigationController
        )
        coordinator.delegate = delegate
        return coordinator
    }

    static func makeMainCoordinator(
        delegate: MainFlowCoordinatorDelegate,
        navigationController: UINavigationController
    ) -> Coordinator {
        let coordinator = MainFlowCoordinatorAssembly.build(
            delegate: delegate,
            navigationController: navigationController
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
