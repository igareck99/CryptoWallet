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
        let view = TabItemsViewAssembly.build()
        renderView(view)
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

