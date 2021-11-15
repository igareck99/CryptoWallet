import SwiftUI
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

final class MainFlowCoordinator: Coordinator {

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
        tabBarController.selectedIndex = Tabs.chat.index

        setViewWith(tabBarController, type: .fade, isRoot: true, isNavBarHidden: false)
    }

    // MARK: - Private Methods

    private func buildChatTab() -> UIViewController {
        let rootView = ChatHistoryConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
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
        let viewController = ProfileConfigurator.configuredViewController(delegate: nil)
        let navigation = BaseNavigationController(rootViewController: viewController)
        navigation.tabBarItem = Tabs.profile.item
        return navigation
    }

    // MARK: - Tabs

    enum Tabs: Hashable {
        case chat
        case wallet
        case profile

        var index: Int {
            switch self {
            case .chat:
                return 0
            case .wallet:
                return 1
            case .profile:
                return 2
            }
        }

        var item: UITabBarItem {
            switch self {
            case .chat:
                let image = R.image.tabBar.chat()
                let item = UITabBarItem(
                    title: R.string.localizable.tabChat(),
                    image: image?.withRenderingMode(.alwaysOriginal).tintColor(.darkGray()),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(.blue())
                )
                item.tag = index
                return item
            case .wallet:
                let image = R.image.tabBar.wallet()
                let item = UITabBarItem(
                    title: R.string.localizable.tabWallet(),
                    image: image?.withRenderingMode(.alwaysOriginal).tintColor(.darkGray()),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(.blue())
                )
                item.tag = index
                return item
            case .profile:
                let image = R.image.tabBar.profile()
                let item = UITabBarItem(
                    title: R.string.localizable.tabProfile(),
                    image: image?.withRenderingMode(.alwaysOriginal).tintColor(.darkGray()),
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

// MARK: - MainFlowCoordinator (ChatHistorySceneDelegate)

extension MainFlowCoordinator: ChatHistorySceneDelegate {
    func handleRoomTap(_ room: AuraRoom) {
        let rootView = ChatRoomConfigurator.configuredView(room: room, delegate: nil)
        let viewController = BaseHostingController(rootView: rootView)
        navigationController.pushViewController(viewController, animated: true)
    }
}
