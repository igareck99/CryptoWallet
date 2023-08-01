import Foundation

enum PushNotificationCoordinatorAssembly {
	static func build(
        notificationResponse: UNNotificationResponse,
        delegate: PushNotificationCoordinatorDelegate?,
        toggleFacade: MainFlowTogglesFacadeProtocol
    ) -> Coordinator {
        let userInfo = notificationResponse.notification.request.content.userInfo
        let parser: PushNotificationsParsable = PushNotificationsParser()
        let matrixUseCase = MatrixUseCase.shared
        let pushCoordinator = PushNotificationCoordinator(
            userInfo: userInfo,
            matrixUseCase: matrixUseCase,
            parser: parser,
			delegate: delegate,
            toggleFacade: toggleFacade
		)
		return pushCoordinator
	}
}
