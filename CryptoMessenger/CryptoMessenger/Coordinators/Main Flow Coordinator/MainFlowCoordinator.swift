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
    var renderView: (any View) -> Void

    var navigationController: UINavigationController

    private let togglesFacade: MainFlowTogglesFacadeProtocol

    // MARK: - Lifecycle

    init(navigationController: UINavigationController,
         togglesFacade: MainFlowTogglesFacadeProtocol,
         renderView: @escaping (any View) -> Void) {
        self.navigationController = navigationController
        self.togglesFacade = togglesFacade
        self.renderView = renderView
    }

    // MARK: - Internal Methods

    func start() {
        makeTabBarView()
    }
    
    func startWithView(completion: @escaping (any View) -> Void) {
        
    }

    func makeTabBarView() {
        let view = TabItemsViewAssembly.build(
            chateDelegate: self,
            profileDelegate: self
        )
        renderView(view)
//        let controller = BaseHostingController(rootView: view)
//        controller.navigationController?.navigationBar.isHidden = false
//        setViewWith(controller, type: .fade, isRoot: true, isNavBarHidden: false)
//		delegate?.didEndStartProcess(coordinator: self)
    }

    // MARK: - Scene

    enum Scene {

        // MARK: - Types

        case personalization
        case language
        case typography
        case selectBackground
        case profilePreview
        case profile
        case blockList
        case chatSettings
        case reserveCopy
        case transaction(Int, Int, String)
        case importKey
        case chooseReceiver(Binding<UserReceiverData>)
        case scanner(Binding<String>)
		case transfer(wallet: WalletInfo)
        case facilityApprove(FacilityApproveModel)
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
        case .blockList:
            showBlockListScene()
        case .chatSettings:
            showChatSettings()
        case .reserveCopy:
            showReserveCopyScene()
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

    private func showBlockListScene() {
        let rootView = BlockedListConfigurator.configuredView(delegate: self)
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
    ) { }

    private func showImportKey() { }

	private func showTransferScene(wallet: WalletInfo) { }

    private func showChooseReceiver(address: Binding<UserReceiverData>) { }

    private func showQRScanner(scannedString: Binding<String>) {
        let rootView = WalletAddressScannerConfigurator.configuredView(
            delegate: self,
            scannedCode: scannedString
        )
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

	private func showFacilityApprove(transaction: FacilityApproveModel) { }

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

// MARK: - MainFlowCoordinator (BlockedListSceneDelegate)

extension MainFlowCoordinator: BlockedListSceneDelegate {}

// MARK: - MainFlowCoordinator (ChatSettingsSceneDelegate)

extension MainFlowCoordinator: ChatSettingsSceneDelegate {}

// MARK: - MainFlowCoordinator (ReserveCopySceneDelegate)

extension MainFlowCoordinator: ReserveCopySceneDelegate {}

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

// MARK: - MainFlowCoordinator (SettingsSceneDelegate)

extension MainFlowCoordinator: SettingsSceneDelegate {}


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
