import SwiftUI
import UIKit

final class AppSceneDelegate: UIResponder, UIWindowSceneDelegate {

    weak var navController: UINavigationController?
    var upWindow: PassThroughWindow?
    var keyWindow: UIWindow?
    weak var windowScene: UIWindowScene?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let wScene = scene as? UIWindowScene else { return }
        windowScene = wScene
        configureMainWindow(wScene: wScene)
        configureUpperWindow(wScene: wScene)
    }

    func configureUpperWindow(wScene: UIWindowScene) {

        let rootViewController = UIViewController()
        rootViewController.title = ""
        rootViewController.view.backgroundColor = .clear

        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.view.backgroundColor = .clear
        navigationController.navigationBar.backgroundColor = .clear

        let upperWindow = PassThroughWindow(windowScene: wScene)
        upperWindow.rootViewController = navigationController
        upperWindow.isHidden = false
        upperWindow.windowLevel = UIWindow.Level(rawValue: .greatestFiniteMagnitude)

        self.upWindow = upperWindow
        self.navController = navigationController
        upperWindow.navController = navigationController
        StatusBarCallUseCase.shared.configure(upWindow: upperWindow)
    }

    func configureMainWindow(wScene: UIWindowScene) {
        let window = UIWindow(windowScene: wScene)
        window.rootViewController = AppCoordinatorAssembly.coordinator.controller
        self.keyWindow = window
        window.makeKeyAndVisible()
        StatusBarCallUseCase.shared.configure(window: window)
    }
}

// MARK: - Navigation

extension AppSceneDelegate {
    func push(view: some View) {
        let controller = UIHostingController(rootView: view)
        push(controller: controller)
    }

    func push(controller: UIViewController) {
        guard let navigationController = self.navController else {
            return
        }
        navigationController.pushViewController(controller, animated: true)
    }
}
