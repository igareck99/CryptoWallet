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
        configureCalls()
		return true
	}

    func configureCalls() {
        guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return
        }

        StatusBarCallUseCase.shared.configure(window: window)
    }

//    func application(
//        _ application: UIApplication,
//        configurationForConnecting connectingSceneSession: UISceneSession,
//        options: UIScene.ConnectionOptions
//    ) -> UISceneConfiguration {
//        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
//        if connectingSceneSession.role == .windowApplication {
//            configuration.delegateClass = SceneDelegate.self
//        }
//        return configuration
//    }

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
/*
class SceneDelegate: NSObject, ObservableObject, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard
            let windowScene = scene as? UIWindowScene,
            let keyWindow = windowScene.keyWindow,
            let controller = keyWindow.rootViewController
        else {
            return
        }
        self.window = keyWindow
        debugPrint("SceneDelegate appWindow: \(appWindow)")
        debugPrint("SceneDelegate rootController: \(controller)")
        StatusBarCallUseCase.shared.configure(
            window: keyWindow,
            rootViewController: controller
        )
    }
}
*/
