import UIKit

// MARK: - AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	private var statusBarCallUseCase: StatusBarCallUseCase?
	private var notificationsUseCase: NotificationsUseCaseProtocol?
	private var appDelegateUseCase: AppDelegateUseCaseProtocol?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {

		DependenciesService().configureDependencies()

		let rootNavigationController = BaseNavigationController()
		let appCoordinator = AppCoordinatorAssembly.build(navigationController: rootNavigationController)
		notificationsUseCase = NotificationsUseCaseAssembly.build(appCoordinator: appCoordinator)
		appDelegateUseCase = AppDelegateUseCaseAssembly.build(appCoordinator: appCoordinator)

		let appWindow = UIWindow()
		window = appWindow
		rootNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
		window?.rootViewController = rootNavigationController

		notificationsUseCase?.start()

		// UseCase app delegate'а должен вызываться после всех кейсов проверок флага isAppNotFirstStart
		// т.к. он его изменяет
		appDelegateUseCase?.start()
		window?.makeKeyAndVisible()

		statusBarCallUseCase = StatusBarCallUseCase(appWindow: appWindow)
		statusBarCallUseCase?.configure(window: appWindow, rootViewController: rootNavigationController)
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
		notificationsUseCase?.applicationDidRegisterForRemoteNotifications(deviceToken: deviceToken)
	}

	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		notificationsUseCase?.applicationDidFailRegisterForRemoteNotifications()
	}
}
