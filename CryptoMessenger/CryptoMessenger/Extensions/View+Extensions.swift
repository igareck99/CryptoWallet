import SwiftUI

// MARK: - View ()

extension View {

    // MARK: - Internal Properties

    var uiView: UIView { UIHostingController(rootView: self).view }

    // MARK: - Internal Methods

    func hideTabBar() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let navigation = scene.windows.first?.rootViewController as? UINavigationController
            let tabBarController = navigation?.viewControllers.first as? UITabBarController
            tabBarController?.tabBar.isHidden = true
        }
    }

    func showTabBar() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let navigation = scene.windows.first?.rootViewController as? UINavigationController
            let tabBarController = navigation?.viewControllers.first as? UITabBarController
            tabBarController?.tabBar.isHidden = false
        }
    }
}
