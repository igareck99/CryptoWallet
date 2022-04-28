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

	init(
		appCoordinator: AppCoordinatorProtocol,
		userSettings: UserFlowsStorage,
		keychainService: KeychainServiceProtocol,
		pushNotificationsService: PushNotificationsServiceProtocol
	) {
		self.appCoordinator = appCoordinator
		self.userSettings = userSettings
		self.keychainService = keychainService
		self.pushNotificationsService = pushNotificationsService
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

	private func handleUpdatenOf(deviceToken: Data) {
		keychainService.set(deviceToken, forKey: .pushToken)
		// TODO: Добавить логику работы с Pusher
		// Послать уведомление об обновлении пуш токена
		// Pusher создается по уведомлению об обновлении токена
		MatrixStore.shared.createPusher(with: deviceToken)
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
		if !userSettings.isAuthFlowFinished {
			pendingOperations[Notification.Name.userDidRegistered.rawValue] = { [weak self] in
				guard let self = self else { return }
				self.handleUpdatenOf(deviceToken: deviceToken)
			}
			return
		}

		if userSettings.isLocalAuth {
			pendingOperations[Notification.Name.userDidLoggedIn.rawValue] = { [weak self] in
				guard let self = self else { return }
				self.handleUpdatenOf(deviceToken: deviceToken)
			}
			return
		}

		handleUpdatenOf(deviceToken: deviceToken)
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
