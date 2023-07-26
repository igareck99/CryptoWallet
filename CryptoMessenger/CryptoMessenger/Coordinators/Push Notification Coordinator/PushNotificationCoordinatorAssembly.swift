import Foundation
import UIKit

enum PushNotificationCoordinatorAssembly {
	static func build(
        notificationResponse: UNNotificationResponse,
        navigationController: UINavigationController,
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
			navigationController: navigationController,
			delegate: delegate,
            toggleFacade: toggleFacade
		)
		return pushCoordinator
	}
}
