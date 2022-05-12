import UserNotifications

protocol PushNotificationsUseCaseProtocol {
	func start()

	func applicationDidRegisterForRemoteNotifications(deviceToken: Data)

	func applicationDidFailRegisterForRemoteNotifications()
}

final class PushNotificationsUseCase: NSObject {

	private var pendingOperations = [String: () -> Void]()
	private let pushNotificationsService: PushNotificationsServiceProtocol
	private let keychainService: KeychainServiceProtocol
	private let userSettings: UserFlowsStorage
	private let appCoordinator: AppCoordinatorProtocol
	private let matrixUseCase: MatrixUseCaseProtocol

	init(
		appCoordinator: AppCoordinatorProtocol,
		userSettings: UserFlowsStorage,
		keychainService: KeychainServiceProtocol,
		pushNotificationsService: PushNotificationsServiceProtocol,
		matrixUseCase: MatrixUseCaseProtocol
	) {
		self.appCoordinator = appCoordinator
		self.userSettings = userSettings
		self.keychainService = keychainService
		self.pushNotificationsService = pushNotificationsService
		self.matrixUseCase = matrixUseCase
		super.init()
		self.subscribeToNotifications()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	private func subscribeToNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(userDidLoggedIn),
			name: .userDidLoggedIn,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(userDidRegistered),
			name: .userDidRegistered,
			object: nil
		)
	}

	@objc private func userDidLoggedIn() {
		pendingOperations[Notification.Name.userDidLoggedIn.rawValue]?()
	}

	@objc private func userDidRegistered() {
		pendingOperations[Notification.Name.userDidRegistered.rawValue]?()
	}

	private func handleUpdateOf(deviceToken: Data) {
		// Если пуш токен обновился, то обновляем пушер
		guard pushNotificationsService.isRegisteredForRemoteNotifications,
			  keychainService[.pushToken] != deviceToken,
			  keychainService.set(deviceToken, forKey: .pushToken)
		else { return }
		matrixUseCase.createPusher(with: deviceToken) { [weak self] in
			debugPrint("SET PUSHER RESULT: \($0)")
			self?.userSettings[.isPushNotificationsEnabled] = $0
		}
	}

	private func updatePush(token: Data) {
		// Удаляем старай пуш токен, если приложение было удалено)
		if userSettings[.isAppNotFirstStart] == false {
			userSettings[.isAppNotFirstStart] = true
			keychainService.removeObject(forKey: .pushToken)
		}
	}
}

// MARK: - PushNotificationsUseCaseProtocol

extension PushNotificationsUseCase: PushNotificationsUseCaseProtocol {

	func start() {

		UNUserNotificationCenter.current().delegate = self

		pushNotificationsService.requestForRemoteNotificationsAuthorizationStatus { [weak self] settings in
			guard let self = self else { return }

			// Если пользователь разрешил уведомления, то сразу пробуем зарегистрироваться
			if settings.authorizationStatus == .authorized {
				self.pushNotificationsService.registerForRemoteNotifications()
				return
			}

			// Запрашиваем разрешение на пуш уведомление,
			// если пользователь еще не принял решение
			guard settings.authorizationStatus == .notDetermined else { return }
			self.pushNotificationsService.requestForRemoteNotificationsAuthorizationState(
				options: [.alert, .sound, .badge]
			) { isAllowed in
				// Регистрируем устройство для пуш уведомлений, если пользователь нажал разрешил
				guard isAllowed else { return }
				self.pushNotificationsService.registerForRemoteNotifications()
			}
		}
	}

	func applicationDidRegisterForRemoteNotifications(deviceToken: Data) {

		updatePush(token: deviceToken)

		if !userSettings.isAuthFlowFinished {
			pendingOperations[Notification.Name.userDidRegistered.rawValue] = { [weak self] in
				guard let self = self else { return }
				self.handleUpdateOf(deviceToken: deviceToken)
			}
			return
		}

		if userSettings.isLocalAuth {
			pendingOperations[Notification.Name.userDidLoggedIn.rawValue] = { [weak self] in
				guard let self = self else { return }
				self.handleUpdateOf(deviceToken: deviceToken)
			}
			return
		}

		handleUpdateOf(deviceToken: deviceToken)
	}

	func applicationDidFailRegisterForRemoteNotifications() {
		// TODO: Обработать этот кейс
	}
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationsUseCase: UNUserNotificationCenterDelegate {

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		completionHandler([.sound, .badge, .list, .banner])
	}

	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		appCoordinator.didReceive(
			notification: response,
			completion: completionHandler
		)
	}
}
