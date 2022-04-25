import UIKit

// MARK: - AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow? = UIWindow()

	private lazy var appCoordinator: Coordinator & AppCoordinatorProtocol = {
		let rootNavigationController = BaseNavigationController()
		window?.rootViewController = rootNavigationController
		return AppCoordinatorAssembly.build(navigationController: rootNavigationController)
	}()

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		UNUserNotificationCenter.current().delegate = self
		appCoordinator.start()
		window?.makeKeyAndVisible()
		return true
	}
}

// MARK: - Notifications

extension AppDelegate {

	func application(
		_ application: UIApplication,
		didReceiveRemoteNotification userInfo: [AnyHashable: Any],
		fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
	) {
		completionHandler(.noData)
	}

	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let token = deviceToken.base64EncodedString()
		debugPrint("didRegisterForRemoteNotificationsWithDeviceToken: \(token.debugDescription)")
	}

	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		debugPrint("didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
	}
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		completionHandler([.banner, .list, .badge, .sound])
	}

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		appCoordinator.didReceive(notification: response, completion: completionHandler)
	}
}
