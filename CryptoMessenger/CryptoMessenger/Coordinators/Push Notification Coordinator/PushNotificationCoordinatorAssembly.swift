import Foundation
import UIKit

//swiftlint:disable: vertical_parameter_alignment

enum PushNotificationCoordinatorAssembly {
	static func build(
		getChatRoomSceneDelegate: @escaping () -> ChatRoomSceneDelegate?,
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
			getChatRoomSceneDelegate: getChatRoomSceneDelegate,
			parser: parser,
			navigationController: navigationController,
			delegate: delegate,
            toggleFacade: toggleFacade
		)
		return pushCoordinator
	}
}
