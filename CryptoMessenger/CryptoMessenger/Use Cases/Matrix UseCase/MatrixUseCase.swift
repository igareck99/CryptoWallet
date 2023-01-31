import Combine
import Foundation

final class MatrixUseCase {

	private let matrixService: MatrixServiceProtocol
	private let keychainService: KeychainServiceProtocol
	private let userSettings: UserDefaultsServiceProtocol
	private var roomsTimer: AnyPublisher<Date, Never>?
	private var subscriptions = Set<AnyCancellable>()
	private let toggles: MatrixUseCaseTogglesProtocol

	static let shared = MatrixUseCase()

	init(
		matrixService: MatrixServiceProtocol = MatrixService.shared,
		keychainService: KeychainServiceProtocol = KeychainService.shared,
		userSettings: UserDefaultsServiceProtocol = UserDefaultsService.shared,
		toggles: MatrixUseCaseTogglesProtocol = MatrixUseCaseToggles()
	) {
		self.matrixService = matrixService
		self.keychainService = keychainService
		self.userSettings = userSettings
		self.toggles = toggles
		observeLoginState()
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
	private func updateCredentialsIfAvailable() {
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

	// MARK: - Session

	var matrixSession: MXSession? { matrixService.matrixSession }

	func loginUser(
		userId: String,
		password: String,
		homeServer: URL,
		completion: @escaping EmptyResultBlock
	) {
		matrixService.updateClient(with: homeServer)

		matrixService.login(userId: userId, password: password, homeServer: homeServer) { [weak self] result in

			guard case .success(let credentials) = result else {
				self?.matrixService.updateState(with: .failure(.loginFailure))
				completion(.failure)
				return
			}

			self?.save(credentials: credentials)
			self?.matrixService.updateService(credentials: credentials)

			self?.matrixService.initializeSessionStore { result in

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
					completion(.success)
				}

			}

		}
	}

	func closeSession() {
		matrixService.closeSessionAndClearData()
	}

	// MARK: - Rooms

	func isDirectRoomExists(userId: String) -> Bool {
		matrixService.isDirectRoomExists(userId: userId)
	}

	func leaveRoom(roomId: String, completion: @escaping (MXResponse<Void>) -> Void) {
		matrixService.leaveRoom(roomId: roomId, completion: completion)
	}

	func joinRoom(roomId: String, completion: @escaping (MXResponse<MXRoom>) -> Void) {
		matrixService.joinRoom(roomId: roomId, completion: completion)
	}

	func createRoom(parameters: MXRoomCreationParameters, completion: @escaping (MXResponse<MXRoom>) -> Void) {
		matrixService.createRoom(parameters: parameters, completion: completion)
	}

	func uploadData(data: Data, for room: MXRoom, completion: @escaping GenericBlock<URL?>) {
		matrixService.uploadData(data: data, for: room, completion: completion)
	}

	func setRoomAvatar(data: Data, for room: MXRoom, completion: @escaping EmptyResultBlock) {
		matrixService.uploadData(data: data, for: room) { link in
			guard let link = link else { completion(.failure); return }
			room.setAvatar(url: link) { [weak self] response in
				guard case .success = response else { completion(.failure); return }
				completion(.success)
				self?.objectChangePublisher.send()
			}
		}
	}
    
    func getRoomState(roomId: String, completion: @escaping EmptyFailureBlock<MXRoomState>) {

        let matrixRoom = matrixService.rooms.first(where: { $0.room.roomId == roomId })?.room
        guard let room = matrixRoom else { completion(.failure); return }
        
        room.liveTimeline { timeline in
            guard let state = timeline?.state else { completion(.failure); return }
            completion(.success(state))
        }
    }

	// MARK: - Remove device by ID
	func getDevicesWithActiveSessions(completion: @escaping (Result<[MXDevice], Error>) -> Void) {
		matrixService.getDevicesWithActiveSessions(completion: completion)
	}

	func logoutDevices(completion: @escaping EmptyResultBlock) {
		matrixService.getDevicesWithActiveSessions { [weak self] result in

			guard case .success(let userDevices) = result else { return }

			self?.matrixService.remove(userDevices: userDevices, completion: completion)
		}
	}

	// MARK: - Users
	func getUserId() -> String {
		matrixService.getUserId()
	}

	func getUser(_ id: String) -> MXUser? {
		matrixService.getUser(id)
	}

	func allUsers() -> [MXUser] {
		matrixService.allUsers()
	}

	func fromCurrentSender(_ userId: String) -> Bool {
		matrixService.fromCurrentSender(userId)
	}

	func searchUser(_ id: String, completion: @escaping GenericBlock<String?>) {
		matrixService.searchUser(id, completion: completion)
	}

	func getDisplayName() -> String {
		matrixService.getDisplayName()
	}

	func getStatus() -> String {
		matrixService.getStatus()
	}

	func getAvatarUrl(completion: @escaping (String) -> Void) {
        matrixService.getAvatarUrl { result in
            completion(result)
        }
	}

	func setDisplayName(_ displayName: String, completion: @escaping VoidBlock) {
		matrixService.setDisplayName(displayName, completion: completion)
	}

	func setStatus(_ status: String, completion: @escaping VoidBlock) {
		matrixService.setStatus(status, completion: completion)
	}

	func setUserAvatarUrl(_ data: Data, completion: @escaping GenericBlock<URL?>) {
		matrixService.uploadUser(data: data) { [weak self] url in

			guard let avatarUrl = url else { completion(nil); return }

			self?.matrixService.setUser(avatarUrl: avatarUrl) { result in

				guard case .success = result  else { completion(nil); return }

				let homeServer = Bundle.main.object(for: .matrixURL).asURL()
				let url = MXURL(mxContentURI: avatarUrl)?.contentURL(on: homeServer)
				completion(url)
			}
		}
	}
    
    func inviteUser(
        userId: String,
        roomId: String,
        completion: @escaping EmptyResultBlock
    ) {
        matrixService.inviteUser(userId: userId, roomId: roomId, completion: completion)
    }
    
    func kickUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock) {
        matrixService.kickUser(userId: userId, roomId: roomId, reason: reason, completion: completion)
    }
    
    func banUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock) {
        matrixService.banUser(userId: userId, roomId: roomId, reason: reason, completion: completion)
    }
    
    func unbanUser(userId: String, roomId: String, completion: @escaping EmptyResultBlock) {
        matrixService.unbanUser(userId: userId, roomId: roomId, completion: completion)
    }
    
    func leaveRoom(roomId: String, completion: @escaping EmptyResultBlock) {
        matrixService.leaveRoom(roomId: roomId, completion: completion)
    }
    
	// MARK: - Pusher
	func createPusher(with pushToken: Data, completion: @escaping (Bool) -> Void) {
		matrixService.createPusher(with: pushToken, completion: completion)
	}
}

// MARK: - Credentials

extension MatrixUseCase {
	private func save(credentials: MXCredentials) {
		guard let homeServer = credentials.homeServer,
			  let userId = credentials.userId,
			  let accessToken = credentials.accessToken,
			  let deviceId = credentials.deviceId else { return }

		keychainService[.homeServer] = homeServer
		keychainService[.userId] = userId
		keychainService[.accessToken] = accessToken
		keychainService[.deviceId] = deviceId
		debugPrint("Credetials saved")
	}

	func clearCredentials() {
		debugPrint("Credetials clearCredentials START")
		keychainService.removeObject(forKey: .homeServer)
		keychainService.removeObject(forKey: .userId)
		keychainService.removeObject(forKey: .accessToken)
		keychainService.removeObject(forKey: .deviceId)
		debugPrint("Credetials clearCredentials END")
	}

	private func retrievCredentials() -> MXCredentials? {
		guard
			let homeServer: String = keychainService[.homeServer],
			let userId: String = keychainService[.userId],
			let accessToken: String = keychainService[.accessToken],
			let deviceId: String = keychainService[.deviceId]
		else {
			return nil
		}
		let credentials = MXCredentials(
			homeServer: homeServer,
			userId: userId,
			accessToken: accessToken
		)
		credentials.deviceId = deviceId
		return credentials
	}
}
