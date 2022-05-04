import Foundation
import UIKit

enum PushNotificationCoordinatorAssembly {
	static func build(
		getChatRoomSceneDelegate: @escaping () -> ChatRoomSceneDelegate?,
		notificationResponse: UNNotificationResponse,
		navigationController: UINavigationController,
		delegate: PushNotificationCoordinatorDelegate?
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
			delegate: delegate
		)
		return pushCoordinator
	}
}
