import UIKit

// MARK: - AppDelegate

class AppDelegate: UIResponder, UIApplicationDelegate {

    private var notificationsUseCase: NotificationsUseCaseProtocol = {
        NotificationsUseCaseAssembly
            .build(
                appCoordinator: AppCoordinatorAssembly.coordinator
            )
    }()

    private var appLifeCycleDelegate: AppDelegateApplicationLifeCycle = {
        AppCoordinatorAssembly.coordinator
    }()

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {

		DependenciesService().configureDependencies()
		notificationsUseCase.start()

		// UseCase app delegate'а должен вызываться после всех кейсов проверок флага isAppNotFirstStart
		// т.к. он его изменяет
        AppCoordinatorAssembly.coordinator.start()
		return true
	}

	func applicationWillTerminate(_ application: UIApplication) {
        appLifeCycleDelegate.applicationWillTerminate()
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
        appLifeCycleDelegate.applicationDidEnterBackground()
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
        appLifeCycleDelegate.applicationWillEnterForeground()
	}

	func applicationWillResignActive(_ application: UIApplication) {
        appLifeCycleDelegate.applicationWillResignActive()
	}

	func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        appLifeCycleDelegate.applicationProtectedDataWillBecomeUnavailable()
	}

	func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        appLifeCycleDelegate.applicationProtectedDataDidBecomeAvailable()
	}
}

// MARK: - Notifications

extension AppDelegate {

	func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
		notificationsUseCase.applicationDidRegisterForRemoteNotifications(deviceToken: deviceToken)
	}

	func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
		notificationsUseCase.applicationDidFailRegisterForRemoteNotifications()
	}
}
