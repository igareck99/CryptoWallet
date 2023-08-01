import SwiftUI

protocol CoordinatorsFactoryProtocol {
    static func makePinCoordinator(
        delegate: PinCodeFlowCoordinatorDelegate,
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
        delegate: PushNotificationCoordinatorDelegate
    ) -> Coordinator
}

enum CoordinatorsFactory: CoordinatorsFactoryProtocol {

    static func makePinCoordinator(
        delegate: PinCodeFlowCoordinatorDelegate,
        renderView: @escaping RootViewBuilder,
        onLogin: @escaping () -> Void
    ) -> Coordinator {
        let userFlows = UserDefaultsService.shared
        let coordinator = PinCodeFlowCoordinator(
            userFlows: userFlows,
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
        delegate: PushNotificationCoordinatorDelegate
    ) -> Coordinator {
        let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase
        let togglesFacade = MainFlowTogglesFacade(remoteConfigUseCase: remoteConfigUseCase)
        let coordinator = PushNotificationCoordinatorAssembly.build(
            notificationResponse: notification,
            delegate: delegate,
            toggleFacade: togglesFacade
        )
        return coordinator
    }
}
