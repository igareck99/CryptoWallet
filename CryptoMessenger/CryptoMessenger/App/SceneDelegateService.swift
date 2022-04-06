import UIKit

// MARK: - SceneDelegateService

final class SceneDelegateService: NSObject, UIWindowSceneDelegate {

    // MARK: - Private Properties

    private var appCoordinator: AppCoordinator?

    var window: UIWindow?

    // MARK: - Internal Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)

        setupAppCoordinator()
    }

    // MARK: - Internal Methods

    func setupAppCoordinator() {
        window?.rootViewController = BaseNavigationController()

        guard let rootNavigationController = window?.rootViewController as? UINavigationController else {
            fatalError("Root viewController must be inherited from UINavigationController")
        }

        appCoordinator = AppCoordinator(navigationController: rootNavigationController)
        appCoordinator?.start()
        window?.makeKeyAndVisible()
    }
}
