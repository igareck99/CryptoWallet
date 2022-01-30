import SwiftUI
import UIKit

// MARK: - MainFlowCoordinatorDelegate

protocol MainFlowCoordinatorDelegate: AnyObject {
    func userPerformedLogout(coordinator: Coordinator)
}

// MARK: - MainFlowSceneDelegate

protocol MainFlowSceneDelegate: AnyObject {
    func handleNextScene(_ scene: MainFlowCoordinator.Scene)
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

//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = scene.windows.first {
//            window.rootViewController = tabBarController
//        } else {
//            setViewWith(navigationController, type: .fade, isRoot: true, isNavBarHidden: false)
//        }
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
        let rootView = ProfileConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
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

    // MARK: - Scene

    enum Scene {

        // MARK: - Types

        case chatRoom(AuraRoom)
        case profileDetail
        case personalization
        case language
        case typography
        case selectBackground
        case profilePreview
        case profile
        case security
        case blockList
        case pinCodeCreate
        case falsePinCode
        case aboutApp
    }
}

// MARK: - MainFlowCoordinator (MainFlowSceneDelegate)

extension MainFlowCoordinator: MainFlowSceneDelegate {
    func handleNextScene(_ scene: Scene) {
        switch scene {
        case let .chatRoom(room):
            showChatRoomScene(room: room)
        case .profileDetail:
            showProfileDetailScene()
        case .personalization:
            showPersonalizationScene()
        case .language:
            showLanguageScene()
        case .typography:
            showTypographyScene()
        case .selectBackground:
            showSelectBackgroundScene()
        case .profilePreview:
            showProfilePreviewScene()
        case .profile:
            start()
        case .security:
            showSecurityScene()
        case .blockList:
            showBlockListScene()
        case .pinCodeCreate:
            showPinCodeCreate()
        case .falsePinCode:
            showFalsePinCode()
        case .aboutApp:
            showAboutAppScene()
        }
    }

    func switchFlow() {
        delegate?.userPerformedLogout(coordinator: self)
    }

    private func showChatRoomScene(room: AuraRoom) {
        let rootView = ChatRoomConfigurator.configuredView(room: room, delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showProfileDetailScene() {
        let rootView = ProfileDetailConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showPersonalizationScene() {
        let rootView = PersonalizationConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showLanguageScene() {
        let rootView = LanguageViewConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showTypographyScene() {
        let rootView = TypographyViewConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showSelectBackgroundScene() {
        let rootView = SelectBackgroundConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showProfilePreviewScene() {
        let rootView = ProfileBackgroundViewConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showSecurityScene() {
        let rootView = SecurityNewConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showBlockListScene() {
        let rootView = BlockedListConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showPinCodeCreate() {
        let rootView = PinCodeCreateConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showFalsePinCode() {
        let rootView = FalsePinCodeConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showAboutAppScene() {
        let viewController = AboutAppConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - MainFlowCoordinator (ChatHistorySceneDelegate)

extension MainFlowCoordinator: ChatHistorySceneDelegate {}

// MARK: - MainFlowCoordinator (ChatRoomSceneDelegate)

extension MainFlowCoordinator: ChatRoomSceneDelegate {}

// MARK: - MainFlowCoordinator (ProfileSceneDelegate)

extension MainFlowCoordinator: ProfileSceneDelegate {}

// MARK: - MainFlowCoordinator (PersonalizationSceneDelegate)

extension MainFlowCoordinator: PersonalizationSceneDelegate {}

// MARK: - MainFlowCoordinator (SecurityNewSceneDelegate)

extension MainFlowCoordinator: SecurityNewSceneDelegate {}

// MARK: - MainFlowCoordinator (BlockedListSceneDelegate)

extension MainFlowCoordinator: BlockedListSceneDelegate {}

// MARK: - MainFlowCoordinator (PinCodeCreateSceneDelegate)

extension MainFlowCoordinator: PinCodeCreateSceneDelegate {}

// MARK: - MainFlowCoordinator (FalsePinCodeSceneDelegate)

extension MainFlowCoordinator: FalsePinCodeSceneDelegate {}

// MARK: - MainFlowCoordinator (AboutAppSceneDelegate)

extension MainFlowCoordinator: AboutAppSceneDelegate {}

// MARK: - MainFlowCoordinator (ProfileDetailSceneDelegate)

extension MainFlowCoordinator: ProfileDetailSceneDelegate {
    func restartFlow() {
        delegate?.userPerformedLogout(coordinator: self)
    }
}
