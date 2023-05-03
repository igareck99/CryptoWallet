import UIKit
import MatrixSDK

//swiftlint:disable: vertical_parameter_alignment
protocol PushNotificationCoordinatorDelegate: AnyObject {
	func didFinishFlow(coordinator: Coordinator)
}

final class PushNotificationCoordinator: NSObject {

	var childCoordinators: [String: Coordinator] = [:]
	let navigationController: UINavigationController
	private let userInfo: [AnyHashable: Any]
	private let parser: PushNotificationsParsable
	private let matrixUseCase: MatrixUseCaseProtocol
	private let getChatRoomSceneDelegate: () -> ChatRoomSceneDelegate?
	private weak var delegate: PushNotificationCoordinatorDelegate?
    private var toggleFacade: MainFlowTogglesFacadeProtocol

	init(
		userInfo: [AnyHashable: Any],
		matrixUseCase: MatrixUseCaseProtocol,
		getChatRoomSceneDelegate: @escaping () -> ChatRoomSceneDelegate?,
		parser: PushNotificationsParsable,
		navigationController: UINavigationController,
		delegate: PushNotificationCoordinatorDelegate?,
        toggleFacade: MainFlowTogglesFacadeProtocol
	) {
        self.toggleFacade = toggleFacade

		self.userInfo = userInfo
		self.matrixUseCase = matrixUseCase
		self.getChatRoomSceneDelegate = getChatRoomSceneDelegate
		self.parser = parser
		self.navigationController = navigationController
		self.delegate = delegate
	}
}

// MARK: - Coordinator

extension PushNotificationCoordinator: Coordinator {

	func start() {
		if let chatRoomDelegate = getChatRoomSceneDelegate(),
		   let matrixEvent = parser.parseMatrixEvent(userInfo: userInfo),
		   let auraRoom = matrixUseCase.rooms.first(where: { $0.room.roomId == matrixEvent.roomId }) {
            let rootView = ChatRoomConfigurator.configuredView(room: auraRoom, delegate: chatRoomDelegate, toggleFacade: toggleFacade)
			let viewController = BaseHostingController(rootView: rootView)
			viewController.hidesBottomBarWhenPushed = true
			navigationController.popToRootViewController(animated: true)
			navigationController.delegate = self
			navigationController.pushViewController(viewController, animated: true)
		}
	}
}

// MARK: - UINavigationControllerDelegate

extension PushNotificationCoordinator: UINavigationControllerDelegate {
	func navigationController(
		_ navigationController: UINavigationController,
		didShow viewController: UIViewController,
		animated: Bool
	) {
		delegate?.didFinishFlow(coordinator: self)
	}
}
