import UIKit

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Private Properties

    private lazy var sceneServices: [UIWindowSceneDelegate] = [
        SceneDelegateService()
    ]

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        sceneServices.forEach {
            _ = $0.scene?(scene, willConnectTo: session, options: connectionOptions)
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
        print(UIApplication.shared.applicationState.rawValue)
    }
}
