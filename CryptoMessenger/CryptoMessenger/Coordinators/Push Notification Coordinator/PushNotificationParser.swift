import Foundation

// MARK: - PushNotificationsParsable

protocol PushNotificationsParsable {
	func parseMatrixEvent(userInfo: [AnyHashable: Any]) -> MatrixNotification?
}

// MARK: - PushNotificationsParsable(PushNotificationsParsable)

struct PushNotificationsParser: PushNotificationsParsable {

    // MARK: - Internal Methods

	func parseMatrixEvent(userInfo: [AnyHashable: Any]) -> MatrixNotification? {
		guard
			let data = try? JSONSerialization.data(withJSONObject: userInfo, options: []),
			let model = try? JSONDecoder().decode(MatrixNotification.self, from: data)
		else {
			return nil
		}
		return model
	}
}
