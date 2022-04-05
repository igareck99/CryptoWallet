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
        tabBarController.selectedIndex = Tabs.chat.rawValue

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
        let rootView = WalletNewConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
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

    enum Tabs: Int, Hashable {

        // MARK: - Types

        case chat = 0
        case wallet = 1
        case profile = 2

        // MARK: - Internal Properties

        var item: UITabBarItem {
            switch self {
            case .chat:
                let image = R.image.tabBar.chat()
                let item = UITabBarItem(
                    title: R.string.localizable.tabChat(),
                    image: image?.withRenderingMode(.alwaysOriginal).tintColor(.darkGray()),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(.blue())
                )
                item.tag = rawValue
                return item
            case .wallet:
                let image = R.image.tabBar.wallet()
                let item = UITabBarItem(
                    title: R.string.localizable.tabWallet(),
                    image: image?.withRenderingMode(.alwaysOriginal).tintColor(.darkGray()),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(.blue())
                )
                item.tag = rawValue
                return item
            case .profile:
                let image = R.image.tabBar.profile()
                let item = UITabBarItem(
                    title: R.string.localizable.tabProfile(),
                    image: image?.withRenderingMode(.alwaysOriginal).tintColor(.darkGray()),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(.blue())
                )
                item.tag = rawValue
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
        case pinCode(PinCodeScreenType)
        case session
        case aboutApp
        case faq
        case chatSettings
        case reserveCopy
        case transaction(Int, Int, String)
        case importKey
        case chooseReceiver
        case scanner(Binding<String>)
        case transfer
        case facilityApprove
        case socialList
        case walletManager
        case keyList
        case phraseManager
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
        case .aboutApp:
            showAboutAppScene()
        case .session:
            showSessionScene()
        case let .pinCode(screenType):
            showPinCodeCreate(screenType: screenType)
        case .chatSettings:
            showChatSettings()
        case .reserveCopy:
            showReserveCopyScene()
        case .faq:
            showAnswerScene()
        case let .transaction(selectorFilterIndex, selectorTokenIndex, address):
            showTransaction(
                selectorFilterIndex: selectorFilterIndex,
                selectorTokenIndex: selectorTokenIndex,
                address: address
            )
        case .importKey:
            showImportKey()
        case .transfer:
            showTransferScene()
        case .facilityApprove:
            showFacilityApprove()
        case .chooseReceiver:
            showChooseReceiver()
        case let .scanner(scannedString):
            showQRScanner(scannedString: scannedString)
        case .walletManager:
            showWalletManager()
        case .keyList:
            showKeyList()
        case .phraseManager:
            showPhraseManger()
        case .socialList:
            showSocialList()
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

    private func showPinCodeCreate(screenType: PinCodeScreenType) {
        let rootView = PinCodeCreateConfigurator.configuredView(delegate: self, screenType: screenType)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showAboutAppScene() {
        let viewController = AboutAppConfigurator.configuredViewController(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showSessionScene() {
        let rootView = SessionConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showAnswerScene() {
        let rootView = AnswerConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showChatSettings() {
        let rootView = ChatSettingsConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showReserveCopyScene() {
        let rootView = ReserveCopyConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showTransaction(
        selectorFilterIndex: Int = 0,
        selectorTokenIndex: Int = 0,
        address: String = ""
    ) {
        let rootView = TransactionConfigurator.configuredView(
            delegate: self,
            selectorFilterIndex: selectorFilterIndex,
            selectorTokenIndex: selectorTokenIndex,
            address: address
        )
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showImportKey() {
        let rootView = ImportKeyConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showTransferScene() {
        let rootView = TransferConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showChooseReceiver() {
        let rootView = ChooseReceiverConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showQRScanner(scannedString: Binding<String>) {
        let rootView = WalletAddressScannerConfigurator.configuredView(
            delegate: self,
            scannedCode: scannedString
        )
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showFacilityApprove() {
        let rootView = FacilityApproveConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showSocialList() {
        let rootView = SocialListConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showWalletManager() {
        let rootView = WalletManagerConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showKeyList() {
        let rootView = KeyListConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showPhraseManger() {
        let rootView = PhraseManagerConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
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

// MARK: - MainFlowCoordinator (SessionSceneDelegate)

extension MainFlowCoordinator: SessionSceneDelegate {}

// MARK: - MainFlowCoordinator (ChatSettingsSceneDelegate)

extension MainFlowCoordinator: ChatSettingsSceneDelegate {}

// MARK: - MainFlowCoordinator (ReserveCopySceneDelegate)

extension MainFlowCoordinator: ReserveCopySceneDelegate {}

// MARK: - MainFlowCoordinator (AboutAppSceneDelegate)

extension MainFlowCoordinator: AboutAppSceneDelegate {}

// MARK: - MainFlowCoordinator (AnswersSceneDelegate)

extension MainFlowCoordinator: AnswersSceneDelegate {}

// MARK: - MainFlowCoordinator (WalletNewSceneDelegate)

extension MainFlowCoordinator: WalletNewSceneDelegate {}

// MARK: - MainFlowCoordinator (TransactionSceneDelegate)

extension MainFlowCoordinator: TransactionSceneDelegate {}

// MARK: - MainFlowCoordinator (ImportKeySceneDelegate)

extension MainFlowCoordinator: ImportKeySceneDelegate {}

// MARK: - MainFlowCoordinator (TransferSceneDelegate)

extension MainFlowCoordinator: TransferSceneDelegate {}

// MARK: - MainFlowCoordinator (ChooseReceiverSceneDelegate)

extension MainFlowCoordinator: ChooseReceiverSceneDelegate {}

// MARK: - MainFlowCoordinator (WalletAddressScanerSceneDelegate)

extension MainFlowCoordinator: WalletAddressScanerSceneDelegate {}

// MARK: - MainFlowCoordinator (FacilityApproveSceneDelegate)

extension MainFlowCoordinator: FacilityApproveSceneDelegate {}

// MARK: - MainFlowCoordinator (WalletManagerSceneDelegate)

extension MainFlowCoordinator: WalletManagerSceneDelegate {}

// MARK: - MainFlowCoordinator (KeyListSceneDelegate)

extension MainFlowCoordinator: KeyListSceneDelegate {}

// MARK: - MainFlowCoordinator (PhraseManagerSceneDelegate)

extension MainFlowCoordinator: PhraseManagerSceneDelegate {}

// MARK: - MainFlowCoordinator (SocialListSceneDelegate)

extension MainFlowCoordinator: SocialListSceneDelegate {}

// MARK: - MainFlowCoordinator (ProfileDetailSceneDelegate)

extension MainFlowCoordinator: ProfileDetailSceneDelegate {
    func restartFlow() {
        delegate?.userPerformedLogout(coordinator: self)
    }
}
