import Foundation

enum PushNotificationCoordinatorAssembly {
	static func build(
        notificationResponse: UNNotificationResponse,
        delegate: PushNotificationCoordinatorDelegate?
    ) -> Coordinator {
        let userInfo = notificationResponse.notification.request.content.userInfo
        let parser: PushNotificationsParsable = PushNotificationsParser()
        let matrixUseCase = MatrixUseCase.shared
        let router = PushNotificationRouter()
        
        let pushCoordinator = PushNotificationCoordinator(
            userInfo: userInfo,
            matrixUseCase: matrixUseCase,
            parser: parser,
			delegate: delegate,
            toggleFacade: MainFlowTogglesFacade.shared,
            router: router,
            chatsCoordinator: ChatsViewAssemlby.coordinator,
            walletCoordinator: WalletAssembly.coordinator,
            profileCoordinatable: ProfileAssembly.coordinator
		)
		return pushCoordinator
	}
}
