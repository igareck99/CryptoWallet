import SwiftUI
import UIKit

// MARK: - MainFlowCoordinatorDelegate

protocol MainFlowCoordinatorDelegate: AnyObject {
    func userPerformedLogout(coordinator: Coordinator)
	func didEndStartProcess(coordinator: Coordinator)
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
	private weak var rootTabBarController: BaseTabBarController?

    let navigationController: UINavigationController

    private let togglesFacade: MainFlowTogglesFacadeProtocol

	private lazy var onTransactionEnd: (TransactionResult) -> Void = { [weak self] transactionResult in
		let closure = self?.onTransactionEndDisplay?()
		closure?(transactionResult)
	}
	private var onTransactionEndDisplay: (() -> ((TransactionResult) -> Void))?
	// Костыль для связки флоу переводов
	// по-хорошему это должно происходить через storage координатора
	private lazy var onTransactionEndHelper: ( @escaping (TransactionResult) -> Void) -> Void
	= { [weak self] transactionClosure in
		self?.onTransactionEndDisplay = { transactionClosure }
	}

    // MARK: - Lifecycle

    init(navigationController: UINavigationController,
         togglesFacade: MainFlowTogglesFacadeProtocol) {
        self.navigationController = navigationController
        self.togglesFacade = togglesFacade
    }

    // MARK: - Internal Methods

    func start() {
//        let tabs: [UIViewController]
//        if togglesFacade.isWalletAvailable {
//            tabs = [
//                buildChatTab(),
//                buildWalletTab(),
//                buildProfileTab()
//            ]
//        } else {
//            tabs = [
//                buildChatTab(),
//                buildProfileTab()
//            ]
//        }
//        let view = MainFlowView(chatHistoryView: ChatHistoryAssembly.build(self),
//                                walletAssemblyView: WalletAssembly.build(self,
//                                                                         onTransactionEndHelper: onTransactionEndHelper),
//                                profileView: ProfileAssembly.configuredView(self))
        let view = MainFlowView {
            ChatHistoryFlowViewModel(delegate: self).view()
        } walletView: {
            WalletFlowViewModel(delegate: self,
                                onTransactionEndHelper: self.onTransactionEndHelper).view()
        } profileView: {
            ProfileFlowViewModel(delegate: self).view()
        }

        let controller = BaseHostingController(rootView: view)
//        let tabBarController = BaseTabBarController(viewControllers: tabs)
//        tabBarController.selectedIndex = Tabs.chat.rawValue
//		rootTabBarController = tabBarController

        setViewWith(controller, type: .fade, isRoot: true, isNavBarHidden: false)
		delegate?.didEndStartProcess(coordinator: self)
    }

    // MARK: - Tabs

    enum Tabs: Int, Hashable {

        // MARK: - Types

        case chat = 0
        case wallet = 1
        case profile = 2

        // MARK: - Internal Properties

        var item: UITabBarItem {
			let tintColor = Palette.custom(.init(133, 135, 141))
			let selectedTintColor = Palette.custom(.init(14, 142, 243))
            switch self {
            case .chat:
                let image = R.image.tabBar.chat()
                let item = UITabBarItem(
                    title: R.string.localizable.tabChat(),
                    image: image?.withRenderingMode(.alwaysOriginal).tintColor(tintColor),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(selectedTintColor)
                )
                item.tag = rawValue
                return item
            case .wallet:
                let image = R.image.tabBar.wallet()
                let item = UITabBarItem(
                    title: R.string.localizable.tabWallet(),
                    image: image?.withRenderingMode(.alwaysOriginal).tintColor(tintColor),
                    selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(selectedTintColor)
                )
                item.tag = rawValue
                return item
            case .profile:
                let image = R.image.tabBar.profile()
                let item = UITabBarItem(
                    title: R.string.localizable.tabProfile(),
                    image: image?.withRenderingMode(.alwaysOriginal).tintColor(tintColor),
					selectedImage: image?.withRenderingMode(.alwaysOriginal).tintColor(selectedTintColor)
                )
                item.tag = rawValue
                return item
            }
        }
    }

    // MARK: - Scene

    enum Scene {

        // MARK: - Types

        case profileDetail(Binding<UIImage?>)
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
        case chooseReceiver(Binding<UserReceiverData>)
        case scanner(Binding<String>)
		case transfer(wallet: WalletInfo)
        case facilityApprove(FacilityApproveModel)
        case notifications
        case socialList
        case walletManager
        case keyList
        case phraseManager
		case popToRoot
        case reservePhraseCopy
    }
}

// MARK: - MainFlowCoordinator (MainFlowSceneDelegate)

extension MainFlowCoordinator: MainFlowSceneDelegate {
    func handleNextScene(_ scene: Scene) {
        switch scene {
        case let .profileDetail(image):
            showProfileDetailScene(image: image)
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
        case .transfer(let wallet):
            showTransferScene(wallet: wallet)
        case .facilityApprove(let transaction):
			showFacilityApprove(transaction: transaction)
        case let .chooseReceiver(address):
            showChooseReceiver(address: address)
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
        case .notifications:
            showNotificationsSettings()
        case .popToRoot:
            popToRoot()
        case .reservePhraseCopy:
            showReservePhraseCopy()
        }
    }

	func popToRoot() {
		guard let controller = rootTabBarController else { return }
		navigationController.popToViewController(controller, animated: true)
	}

    func switchFlow() {
        delegate?.userPerformedLogout(coordinator: self)
    }

    private func showNotificationsSettings() {
        let rootView = NotificationSettingsConfigurator.configuredView(delegate: self)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showProfileDetailScene(image: Binding<UIImage?>) {
        let rootView = ProfileDetailConfigurator.configuredView(delegate: self, image: image)
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
        let rootView = SecurityConfigurator.configuredView(delegate: self, togglesFacade: togglesFacade )
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
        let rootView = PinCodeAssembly.build(delegate: self,
                                             screenType: screenType)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showAboutAppScene() {
        let view = AboutAppAssembly.build(delegate: self)
        let viewController = BaseHostingController(rootView: view)
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
        let rootView = ImportKeyConfigurator.configuredView(
            delegate: self,
            navController: navigationController
        )
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

	private func showTransferScene(wallet: WalletInfo) {
        let rootView = TransferConfigurator.configuredView(
			wallet: wallet,
			delegate: self
		)
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showChooseReceiver(address: Binding<UserReceiverData>) {
        let rootView = ChooseReceiverConfigurator.configuredView(delegate: self, receiverData: address)
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

	private func showFacilityApprove(transaction: FacilityApproveModel) {
		let rootView = FacilityApproveConfigurator
			.configuredView(
				transaction: transaction,
				delegate: self,
				onTransactionEnd: onTransactionEnd
			)
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

    private func showReservePhraseCopy() {
        let rootView = ReservePhraseCopyConfigurator.configuredView(delegate: self)
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

// MARK: - MainFlowCoordinator (SecuritySceneDelegate)

extension MainFlowCoordinator: SecuritySceneDelegate {}

// MARK: - MainFlowCoordinator (BlockedListSceneDelegate)

extension MainFlowCoordinator: BlockedListSceneDelegate {}

// MARK: - MainFlowCoordinator (PinCodeCreateSceneDelegate)

extension MainFlowCoordinator: PinCodeSceneDelegate {
    func handleNextScene() {
    }
}

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

// MARK: - MainFlowCoordinator (WalletSceneDelegate)

extension MainFlowCoordinator: WalletSceneDelegate {}

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

// MARK: - MainFlowCoordinator (SettingsSceneDelegate)

extension MainFlowCoordinator: SettingsSceneDelegate {}

// MARK: - MainFlowCoordinator (NotificationSettingsSceneDelegate)

extension MainFlowCoordinator: NotificationSettingsSceneDelegate {}

// MARK: - MainFlowCoordinator (GeneratePhraseSceneDelegate)

extension MainFlowCoordinator: GeneratePhraseSceneDelegate {}

// MARK: - MainFlowCoordinator (ReservePhraseCopySceneDelegate)

extension MainFlowCoordinator: ReservePhraseCopySceneDelegate {}

// MARK: - MainFlowCoordinator (ProfileDetailSceneDelegate)

extension MainFlowCoordinator: ProfileDetailSceneDelegate {
    func restartFlow() {
        delegate?.userPerformedLogout(coordinator: self)
    }
}
