import UIKit

// MARK: - MainFlowCoordinatorDelegate

protocol MainFlowCoordinatorDelegate: AnyObject {
    func userPerformedLogout(coordinator: Coordinator)
}

// MARK: - MainFlowSceneDelegate

protocol MainFlowSceneDelegate: AnyObject {
    func switchFlow()
}

// MARK: - MainFlowCoordinator

public final class MainFlowCoordinator: Coordinator {

    // MARK: - Internal Properties

    var childCoordinators: [String: Coordinator] = [:]
    weak var delegate: MainFlowCoordinatorDelegate?

    let navigationController: UINavigationController

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Internal Methods

    func start() {
        let tabs = [
            buildChatTab(),
            buildWalletTab(),
            buildProfileTab()
        ]

        let tabBarController = BaseTabBarController(viewControllers: tabs)

        setViewWith(tabBarController, type: .fade, isRoot: true, isNavBarHidden: false)
    }

    // MARK: - Private Methods

    private func buildServicesTab() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.background(.white())
        let navigation = BaseNavigationController(rootViewController: viewController)
        navigation.tabBarItem = Tabs.services.item
        return navigation
    }

    private func buildChatTab() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.background(.white())
        let navigation = BaseNavigationController(rootViewController: viewController)
        navigation.tabBarItem = Tabs.chat.item
        return navigation
    }

    private func buildWalletTab() -> UIViewController {
        let viewController = WalletConfigurator.configuredViewController(delegate: nil)
        let navigation = BaseNavigationController(rootViewController: viewController)
        navigation.tabBarItem = Tabs.wallet.item
        return navigation
    }

    private func buildProfileTab() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.background(.white())
        let navigation = BaseNavigationController(rootViewController: viewController)
        navigation.tabBarItem = Tabs.profile.item
        return navigation
    }

    // MARK: - Tabs

    enum Tabs: Hashable {
        case services
        case chat
        case wallet
        case profile

        var index: Int {
            switch self {
            case .services:
                return 0
            case .chat:
                return 1
            case .wallet:
                return 2
            case .profile:
                return 3
            }
        }

        var item: UITabBarItem {
            switch self {
            case .services:
                let image = R.image.tabBar.services()
                let item = UITabBarItem(
                    title: R.string.localizable.tabServices(),
                    image: image?.withRenderingMode(.alwaysOriginal),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(.blue())
                )
                item.tag = index
                return item
            case .chat:
                let image = R.image.tabBar.chat()
                let item = UITabBarItem(
                    title: R.string.localizable.tabChat(),
                    image: image?.withRenderingMode(.alwaysOriginal),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(.blue())
                )
                item.tag = index
                return item
            case .wallet:
                let image = R.image.tabBar.wallet()
                let item = UITabBarItem(
                    title: R.string.localizable.tabWallet(),
                    image: image?.withRenderingMode(.alwaysOriginal),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(.blue())
                )
                item.tag = index
                return item
            case .profile:
                let image = R.image.tabBar.profile()
                let item = UITabBarItem(
                    title: R.string.localizable.tabProfile(),
                    image: image?.withRenderingMode(.alwaysOriginal),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(.blue())
                )
                item.tag = index
                return item
            }
        }
    }
}

// MARK: - MainFlowCoordinator (MainFlowSceneDelegate)

extension MainFlowCoordinator: MainFlowSceneDelegate {
    func switchFlow() {
        delegate?.userPerformedLogout(coordinator: self)
    }
}
