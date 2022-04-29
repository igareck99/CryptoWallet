import UIKit

protocol PushNotificationsServiceProtocol {

	var isRegisteredForRemoteNotifications: Bool { get }

	func registerForRemoteNotifications()

	func requestForRemoteNotificationsAuthorizationState(
		options: UNAuthorizationOptions,
		completion: @escaping (Bool) -> Void
	)

	func requestForRemoteNotificationsAuthorizationStatus(
		completion: @escaping (UNNotificationSettings) -> Void
	)
}

final class PushNotificationsService: NSObject {

	private let notificationCenter: UNUserNotificationCenter
	private let application: UIApplication

	init(
		application: UIApplication = .shared,
		notificationCenter: UNUserNotificationCenter = .current()
	) {
		self.application = application
		self.notificationCenter = notificationCenter
	}
}

// MARK: - PushNotificationsServiceProtocol

extension PushNotificationsService: PushNotificationsServiceProtocol {

	func requestForRemoteNotificationsAuthorizationState(
		options: UNAuthorizationOptions,
		completion: @escaping (Bool) -> Void
	) {
		notificationCenter.requestAuthorization(options: options) { isAllowed, error in
			debugPrint("Permission granted: \(isAllowed)")
			debugPrint("Permission error: \(error.debugDescription)")
			completion(isAllowed)
		}
	}

	func requestForRemoteNotificationsAuthorizationStatus(
		completion: @escaping (UNNotificationSettings) -> Void
	) {
		notificationCenter.getNotificationSettings { settings in
			debugPrint("Notification settings: \(settings)")
			completion(settings)
		}
	}

	func registerForRemoteNotifications() {
		DispatchQueue.main.async { [weak self] in
			self?.application.registerForRemoteNotifications()
		}
	}

	var isRegisteredForRemoteNotifications: Bool {
		application.isRegisteredForRemoteNotifications
	}
}
