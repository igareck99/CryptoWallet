import Combine
import Foundation
import MatrixSDK

// swiftlint:disable all

// MARK: - MatrixUseCase

final class MatrixUseCase {

    // MARK: - Private Properties

    let matrixService: MatrixServiceProtocol
    let config: ConfigType
    let cache: ImageCacheServiceProtocol
    let jitsiFactory: JitsiWidgetFactoryProtocol.Type
    let keychainService: KeychainServiceProtocol
    let userSettings: UserDefaultsServiceProtocol & UserCredentialsStorage
	private var roomsTimer: AnyPublisher<Date, Never>?
	private var subscriptions = Set<AnyCancellable>()
	private let toggles: MatrixUseCaseTogglesProtocol

    // MARK: - Static Properties

	static let shared = MatrixUseCase()
    
    // MARK: - Lifecycle

    init(
        matrixService: MatrixServiceProtocol = MatrixService.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        userSettings: UserDefaultsServiceProtocol & UserCredentialsStorage = UserDefaultsService.shared,
        toggles: MatrixUseCaseTogglesProtocol = MatrixUseCaseToggles(),
        config: ConfigType = Configuration.shared,
        cache: ImageCacheServiceProtocol = ImageCacheService.shared,
        jitsiFactory: JitsiWidgetFactoryProtocol.Type = JitsiWidgetFactory.self
    ) {
      self.matrixService = matrixService
      self.keychainService = keychainService
      self.userSettings = userSettings
      self.toggles = toggles
      self.config = config
      self.cache = cache
      self.jitsiFactory = jitsiFactory
      observeLoginState()
      observeSessionToken()
	}

    // MARK: - Private Methods
    
    private func observeSessionToken() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(tokenRefreshed),
                name: .didRefreshToken,
                object: nil
            )
    }
    
    @objc func tokenRefreshed() {
        guard let apiToken: String = keychainService.apiAccessToken,
              let userId: String = userSettings.userId,
              let deviceId: String = keychainService[.deviceId]
        else {
            return
        }

        let homeServer = config.matrixURL
        loginByJWT(
            token: apiToken,
            deviceId: deviceId,
            userId: userId,
            homeServer: homeServer
        ) { result in
            
            if case .success = result {
                debugPrint("MatrixUseCase tokenRefreshed loginByJWT TOKEN REFRESHED")
            } else {
                debugPrint("MatrixUseCase tokenRefreshed loginByJWT TOKEN NOT REFRESHED")
            }
        }
    }

	private func observeLoginState() {
		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(userDidLoggedIn),
				name: .userDidLoggedIn,
				object: nil
			)
	}

	@objc func userDidLoggedIn() {
 		matrixService.updateState(with: .loggedIn(userId: matrixService.getUserId()))
		updateCredentialsIfAvailable()
		guard toggles.isRoomsUpdateTimerAvailable else { return }

		debugPrint("makeAndBindTimer CALLED")
		makeAndBindTimer()
	}

    // MARK: - Костыль для принудительного обнровления списка комнат
	private func makeAndBindTimer() {
		roomsTimer = Timer
			.publish(every: 0.5, on: RunLoop.main, in: .default)
			.autoconnect()
			.prefix(untilOutputFrom: Just(()).delay(for: 30, scheduler: RunLoop.main))
			.eraseToAnyPublisher()

		roomsTimer?
			.receive(on: RunLoop.main)
			.sink(receiveValue: { [weak self] _ in
				self?.objectChangePublisher.send()
			}).store(in: &subscriptions)
	}

	// TODO: Отрефачить логику входа по пин коду
    func updateCredentialsIfAvailable() {
		guard let credentials = retrievCredentials() else { return }
		matrixService.updateService(credentials: credentials)
		matrixService.initializeSessionStore { [weak self] result in

			guard case .success = result else {
				self?.matrixService.updateState(with: .failure(.loginFailure))
				return
			}

			self?.matrixService.startSession { result in
				guard case .success = result, let userId = credentials.userId else {
					self?.matrixService.updateState(with: .failure(.loginFailure))
					return
				}

				self?.matrixService.configureFetcher()
				self?.matrixService.updateState(with: .loggedIn(userId: userId))
				self?.matrixService.updateUnkownDeviceWarn(isEnabled: false)
				self?.matrixService.startListeningForRoomEvents()
			}

		}
	}
}

// MARK: - MatrixUseCaseProtocol

extension MatrixUseCase: MatrixUseCaseProtocol {
	var objectChangePublisher: ObservableObjectPublisher { matrixService.objectChangePublisher }
	var loginStatePublisher: Published<MatrixState>.Publisher { matrixService.loginStatePublisher }
	var devicesPublisher: Published<[MXDevice]>.Publisher { matrixService.devicesPublisher }
	var rooms: [AuraRoom] { matrixService.rooms }
    var auraRooms: [AuraRoomData] { matrixService.auraRooms }
    var auraNoEventsRooms: [AuraRoomData] { matrixService.auraNoEventsRooms }

	// MARK: - Session

	var matrixSession: MXSession? { matrixService.matrixSession }
    
    func loginByJWT(
        token: String,
        deviceId: String,
        userId: String,
        homeServer: URL,
        completion: @escaping EmptyFailureBlock<AuraMatrixCredentials>
    ) {
        matrixService.updateClient(with: homeServer)
        matrixService.loginByJWT(
            token: token,
            deviceId: deviceId,
            userId: userId,
            homeServer: homeServer
        ) { [weak self] result in
            self?.handleLogin(response: result, completion: completion)
        }
    }
    
    private func handleLogin(
        response: Result<MXCredentials, Error>,
        completion: @escaping EmptyFailureBlock<AuraMatrixCredentials>
    ) {
        guard case .success(let credentials) = response else {
            matrixService.updateState(with: .failure(.loginFailure))
            completion(.failure)
            return
        }
        
        save(credentials: credentials)
        matrixService.updateService(credentials: credentials)
        
        matrixService.initializeSessionStore { [weak self] result in
            
            guard case .success = result else {
                self?.matrixService.updateState(with: .failure(.loginFailure))
                completion(.failure)
                return
            }
            
            self?.matrixService.startSession { result in
                guard case .success = result, let userId = credentials.userId else {
                    self?.matrixService.updateState(with: .failure(.loginFailure))
                    completion(.failure)
                    return
                }
                
                self?.matrixService.updateState(with: .loggedIn(userId: userId))
                self?.matrixService.updateUnkownDeviceWarn(isEnabled: false)
                self?.matrixService.startListeningForRoomEvents()
                self?.serverSyncWithServerTimeout()

                guard let homeServer = credentials.homeServer,
                      let userId = credentials.userId,
                      let accessToken = credentials.accessToken,
                      let deviceId = credentials.deviceId
                else {
                    completion(.failure)
                    return
                }
                
                let auraMxCredentials = AuraMatrixCredentials(
                    homeServer: homeServer,
                    userId: userId,
                    accessToken: accessToken,
                    deviceId: deviceId
                )
                completion(.success(auraMxCredentials))
            }
        }
    }

	func closeSession() {
		matrixService.closeSessionAndClearData()
	}
    
    // MARK: - Sync
    func serverSyncWithServerTimeout() {
        // TODO: Trigger storage sync with server
        matrixService.matrixSession?.backgroundSync(completion: { response in
            debugPrint("matrixService.matrixSession?.backgroundSync: \(response)")
        })
        
    }  
}
