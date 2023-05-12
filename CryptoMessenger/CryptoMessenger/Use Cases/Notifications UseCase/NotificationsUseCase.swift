import UserNotifications

// swiftlint:disable all

protocol NotificationsUseCaseProtocol {
	func start()

	func applicationDidRegisterForRemoteNotifications(deviceToken: Data)

	func applicationDidFailRegisterForRemoteNotifications()
}

final class NotificationsUseCase: NSObject {

	private var pendingOperations = [String: [VoidBlock]]()
	private let pushNotificationsService: PushNotificationsServiceProtocol
    private var pushKitService: PushKitServiceProtocol?
	private let keychainService: KeychainServiceProtocol
	private let userSettings: UserFlowsStorage
	private let appCoordinator: AppCoordinatorProtocol
	private let matrixUseCase: MatrixUseCaseProtocol

	init(
		appCoordinator: AppCoordinatorProtocol,
		userSettings: UserFlowsStorage,
		keychainService: KeychainServiceProtocol,
		pushNotificationsService: PushNotificationsServiceProtocol,
        pushKitService: PushKitServiceProtocol,
		matrixUseCase: MatrixUseCaseProtocol
	) {
		self.appCoordinator = appCoordinator
		self.userSettings = userSettings
		self.keychainService = keychainService
		self.pushNotificationsService = pushNotificationsService
        self.pushKitService = pushKitService
		self.matrixUseCase = matrixUseCase
		super.init()
		self.subscribeToNotifications()
        self.updatePushTokens()
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
        pendingOperations[Notification.Name.userDidLoggedIn.rawValue]?.forEach { $0() }
        pendingOperations[Notification.Name.userDidLoggedIn.rawValue]?.removeAll()
	}

	@objc private func userDidRegistered() {
        pendingOperations[Notification.Name.userDidRegistered.rawValue]?.forEach { $0() }
        pendingOperations[Notification.Name.userDidRegistered.rawValue]?.removeAll()
    }

	private func handleUpdateOfPush(token: Data) {
		// Если пуш токен обновился, то обновляем пушер
		guard pushNotificationsService.isRegisteredForRemoteNotifications,
			  keychainService[.pushToken] != token,
			  keychainService.set(token, forKey: .pushToken)
		else { return }
        keychainService.set(token, forKey: .pushToken)
		matrixUseCase.createPusher(pushToken: token) { [weak self] in
			self?.userSettings[.isPushNotificationsEnabled] = $0
            debugPrint("NotificationsUseCase handleUpdateOfPush createPusher: \($0)")
		}
	}
    
    private func handleUpdateOfVoip(token: Data) {
        
        if !userSettings.isAuthFlowFinished {
            pendingOperations[Notification.Name.userDidRegistered.rawValue]?.append { [weak self] in
                guard let self = self else { return }
                self.handleUpdateOfVoip(token: token)
            }
            return
        }
        
        if userSettings.isLocalAuth {
            pendingOperations[Notification.Name.userDidLoggedIn.rawValue]?.append { [weak self] in
                guard let self = self else { return }
                self.handleUpdateOfVoip(token: token)
            }
            return
        }
        
        guard keychainService[.pushVoipToken] != token,
              userSettings[.isVoipPusherCreated] == false,
              keychainService.set(token, forKey: .pushVoipToken)
        else { return }
        
        matrixUseCase.createVoipPusher(pushToken: token) { [weak self] in
            self?.userSettings[.isVoipPusherCreated] = $0
            debugPrint("NotificationsUseCase handleUpdateOfVoip createPusher: \($0)")
        }
    }

    private func updatePushTokens() {
		// Удаляем старый пуш/voip токен, если приложение было удалено
		if userSettings[.isAppNotFirstStart] == false {
			keychainService.removeObject(forKey: .pushToken)
            keychainService.removeObject(forKey: .pushVoipToken)
		}
	}
    
    private func requestVoipToken() {
        guard let token = pushKitService?.requestVoipToken() else  { return }
        keychainService.set(token, forKey: .pushVoipToken)
    }
}

// MARK: - NotificationsUseCaseProtocol

extension NotificationsUseCase: NotificationsUseCaseProtocol {

	func start() {
        
        pushKitService?.registerToVoipTokens()
        requestVoipToken()

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
            pendingOperations[Notification.Name.userDidRegistered.rawValue]?.append {
                [weak self] in
                    guard let self = self else { return }
                    self.handleUpdateOfPush(token: deviceToken)
            }
			return
		}

		if userSettings.isLocalAuth {
			pendingOperations[Notification.Name.userDidLoggedIn.rawValue]?.append { [weak self] in
				guard let self = self else { return }
				self.handleUpdateOfPush(token: deviceToken)
			}
			return
		}

        handleUpdateOfPush(token: deviceToken)
	}

	func applicationDidFailRegisterForRemoteNotifications() {
		// TODO: Обработать этот кейс
	}
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationsUseCase: UNUserNotificationCenterDelegate {

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

// MARK: - PushKitServiceDelegate

extension NotificationsUseCase: PushKitServiceDelegate {
    func didUpdateVoip(token: Data) {
        
        pushKitService?.unregisterToVoipTokens()
        
        keychainService.set(token, forKey: .pushVoipToken)
        
        handleUpdateOfVoip(token: token)
        
        pushKitService = nil
    }

    func didInvalidateVoipToken() {
        keychainService.removeObject(forKey: .pushVoipToken)
    }
}
