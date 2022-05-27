import UIKit

// MARK: - AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	private var pushNotificationsUseCase: PushNotificationsUseCaseProtocol?
	private var appDelegateUseCase: AppDelegateUseCaseProtocol?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {

		DependenciesService().configureDependencies()

		let rootNavigationController = BaseNavigationController()
		let appCoordinator = AppCoordinatorAssembly.build(navigationController: rootNavigationController)
		pushNotificationsUseCase = PushNotificationsUseCaseAssembly.build(appCoordinator: appCoordinator)
		appDelegateUseCase = AppDelegateUseCaseAssembly.build(appCoordinator: appCoordinator)

		window = UIWindow()
		window?.rootViewController = rootNavigationController

		pushNotificationsUseCase?.start()
		appDelegateUseCase?.start()
		window?.makeKeyAndVisible()
		return true
	}

	func applicationWillTerminate(_ application: UIApplication) {
		appDelegateUseCase?.applicationWillTerminate()
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		appDelegateUseCase?.applicationDidEnterBackground()
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		appDelegateUseCase?.applicationWillEnterForeground()
	}

	func applicationWillResignActive(_ application: UIApplication) {
		appDelegateUseCase?.applicationWillResignActive()
	}

	func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
		appDelegateUseCase?.applicationProtectedDataWillBecomeUnavailable()
	}

	func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
		appDelegateUseCase?.applicationProtectedDataDidBecomeAvailable()
	}
}

// MARK: - Notifications

extension AppDelegate {

	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		pushNotificationsUseCase?.applicationDidRegisterForRemoteNotifications(deviceToken: deviceToken)
	}

	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		pushNotificationsUseCase?.applicationDidFailRegisterForRemoteNotifications()
	}
}
