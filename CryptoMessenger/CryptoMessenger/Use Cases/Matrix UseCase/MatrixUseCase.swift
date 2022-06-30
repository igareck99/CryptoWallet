import Combine
import Foundation
import MatrixSDK

protocol MatrixUseCaseProtocol {

	var objectChangePublisher: ObservableObjectPublisher { get }
	var loginStatePublisher: Published<MatrixState>.Publisher { get }
	var devicesPublisher: Published<[MXDevice]>.Publisher { get }
	var rooms: [AuraRoom] { get }

	// MARK: - Session
	var matrixSession: MXSession? { get }

	func loginUser(
		userId: String,
		password: String,
		homeServer: URL,
		completion: @escaping EmptyResultBlock
	)

	// MARK: - Rooms
	func isDirectRoomExists(userId: String) -> Bool
	func leaveRoom(roomId: String, completion: @escaping (MXResponse<Void>) -> Void)
	func joinRoom(roomId: String, completion: @escaping (MXResponse<MXRoom>) -> Void)
	func createRoom(parameters: MXRoomCreationParameters, completion: @escaping (MXResponse<MXRoom>) -> Void)
	func uploadData(data: Data, for room: MXRoom, completion: @escaping GenericBlock<URL?>)
	func setRoomAvatar(data: Data, for room: MXRoom, completion: @escaping EmptyResultBlock)

	// MARK: - Pusher
	func createPusher(with pushToken: Data, completion: @escaping (Bool) -> Void)

	// MARK: - Users
	func getUserId() -> String
	func getUser(_ id: String) -> MXUser?
	func allUsers() -> [MXUser]
	func fromCurrentSender(_ userId: String) -> Bool
	func searchUser(_ id: String, completion: @escaping GenericBlock<String?>)
	func getDisplayName() -> String
	func getStatus() -> String
	func getAvatarUrl() -> String
	func setDisplayName(_ displayName: String, completion: @escaping VoidBlock)
	func setStatus(_ status: String, completion: @escaping VoidBlock)
	func setUserAvatarUrl(_ data: Data, completion: @escaping GenericBlock<URL?>)

	// MARK: - Device
	func getDevicesWithActiveSessions(completion: @escaping (Result<[MXDevice], Error>) -> Void)
	func logoutDevices(completion: @escaping EmptyResultBlock)
	func clearCredentials()
}

final class MatrixUseCase {

	private let matrixService: MatrixServiceProtocol
	private let keychainService: KeychainServiceProtocol
	private let userSettings: UserDefaultsServiceProtocol

	static let shared = MatrixUseCase()

	init(
		matrixService: MatrixServiceProtocol = MatrixService.shared,
		keychainService: KeychainServiceProtocol = KeychainService.shared,
		userSettings: UserDefaultsServiceProtocol = UserDefaultsService.shared
	) {
		self.matrixService = matrixService
		self.keychainService = keychainService
		self.userSettings = userSettings
		updateCredentialsIfAvailable()
		observeLoginState()
	}

	private func observeLoginState() {
		NotificationCenter.default
			.addObserver(self, selector: #selector(userDidLoggedIn), name: .userDidLoggedIn, object: nil)
	}

	@objc func userDidLoggedIn() {
		matrixService.updateState(with: .loggedIn(userId: matrixService.getUserId()))
	}

	// TODO: Отрефачить логику входа по пин коду
	private func updateCredentialsIfAvailable() {
		guard let credentials = retrievCredentials() else { return }
		matrixService.updateUser(credentials: credentials)
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

			self?.matrixService.updateUser(credentials: credentials)
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

	// MARK: - Remove device by ID
	func getDevicesWithActiveSessions(completion: @escaping (Result<[MXDevice], Error>) -> Void) {
		matrixService.getDevicesWithActiveSessions(completion: completion)
	}

	func logoutDevices(completion: @escaping EmptyResultBlock) {
		matrixService.getDevicesWithActiveSessions { [weak self] result in

			guard case .success(let userDevices) = result else { return }

			self?.matrixService.remove(userDevices: userDevices)
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

	func getAvatarUrl() -> String {
		matrixService.getAvatarUrl()
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

	// MARK: - Pusher
	func createPusher(with pushToken: Data, completion: @escaping (Bool) -> Void) {
		matrixService.createPusher(with: pushToken, completion: completion)
	}
}

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