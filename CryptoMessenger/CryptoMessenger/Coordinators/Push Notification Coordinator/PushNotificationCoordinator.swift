import Foundation

protocol PushNotificationCoordinatorDelegate: AnyObject {
	func didFinishFlow(coordinator: Coordinator)
}

final class PushNotificationCoordinator<Router: PushNotificationRouterable>: NSObject {

	var childCoordinators: [String: Coordinator] = [:]
	private let userInfo: [AnyHashable: Any]
	private let parser: PushNotificationsParsable
	private let matrixUseCase: MatrixUseCaseProtocol
	private weak var delegate: PushNotificationCoordinatorDelegate?
    private var toggleFacade: MainFlowTogglesFacadeProtocol
    private let router: Router
    private let config: ConfigType
    private weak var chatsCoordinator: ChatsCoordinatable?
    private weak var walletCoordinator: WalletCoordinatable?
    private weak var profileCoordinatable: ProfileCoordinatable?
    private let matrixobjectFactory: MatrixObjectFactoryProtocol

    init(
        userInfo: [AnyHashable: Any],
        matrixUseCase: MatrixUseCaseProtocol,
        parser: PushNotificationsParsable,
        delegate: PushNotificationCoordinatorDelegate?,
        toggleFacade: MainFlowTogglesFacadeProtocol,
        router: Router,
        chatsCoordinator: ChatsCoordinatable?,
        walletCoordinator: WalletCoordinatable?,
        profileCoordinatable: ProfileCoordinatable?,
        config: ConfigType = Configuration.shared,
        matrixobjectFactory: MatrixObjectFactoryProtocol = MatrixObjectFactory()
    ) {
        self.toggleFacade = toggleFacade
        self.userInfo = userInfo
        self.matrixUseCase = matrixUseCase
        self.parser = parser
		self.delegate = delegate
        self.router = router
        self.chatsCoordinator = chatsCoordinator
        self.walletCoordinator = walletCoordinator
        self.profileCoordinatable = profileCoordinatable
        self.config = config
        self.matrixobjectFactory = matrixobjectFactory
	}
}

// MARK: - Coordinator

extension PushNotificationCoordinator: Coordinator {

	func start() {
        guard let matrixEvent: MatrixNotification = parser.parseMatrixEvent(userInfo: userInfo),
              let currentRoom: AuraRoomData = matrixUseCase.rooms.first(
                where: { $0.room.roomId == matrixEvent.roomId }
              ) else {
            return
        }
        chatsCoordinator?.chatRoom(room: currentRoom)
    }
}
