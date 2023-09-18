import Combine
import Foundation
import MatrixSDK

// swiftlint:disable all

// MARK: - MatrixUseCase

final class MatrixUseCase {

    // MARK: - Private Properties

	private let matrixService: MatrixServiceProtocol
	private let keychainService: KeychainServiceProtocol
	private let userSettings: UserDefaultsServiceProtocol
	private var roomsTimer: AnyPublisher<Date, Never>?
	private var subscriptions = Set<AnyCancellable>()
	private let toggles: MatrixUseCaseTogglesProtocol
    private let config: ConfigType
    private let cache: ImageCacheServiceProtocol

    // MARK: - Static Properties

	static let shared = MatrixUseCase()
    
    // MARK: - Lifecycle

    init(
        matrixService: MatrixServiceProtocol = MatrixService.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        userSettings: UserDefaultsServiceProtocol = UserDefaultsService.shared,
        toggles: MatrixUseCaseTogglesProtocol = MatrixUseCaseToggles(),
        config: ConfigType = Configuration.shared,
        cache: ImageCacheServiceProtocol = ImageCacheService.shared
    ) {
		self.matrixService = matrixService
		self.keychainService = keychainService
		self.userSettings = userSettings
		self.toggles = toggles
        self.config = config
        self.cache = cache
		observeLoginState()
	}

    // MARK: - Private Methods

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

// MARK: - MatrixUseCase(MatrixUseCaseProtocol)

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
        completion: @escaping EmptyResultBlock
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
        completion: @escaping EmptyResultBlock
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
                completion(.success)
                self?.serverSyncWithServerTimeout()
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

	// MARK: - Rooms
    
    func createChannel(name: String,
                       topic: String,
                       channelType: ChannelType,
                       roomAvatar: UIImage?,
                       completion: @escaping (RoomCreateState) -> Void) {
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = []
        parameters.isDirect = false
        parameters.name = name
        parameters.topic = topic
        if channelType == .publicChannel {
            parameters.visibility = MXRoomDirectoryVisibility.public.identifier
        } else {
            parameters.visibility = MXRoomDirectoryVisibility.private.identifier
        }
        parameters.preset = MXRoomPreset.privateChat.identifier
        let powerLevelOverride = MXRoomPowerLevels()
        powerLevelOverride.eventsDefault = 50
        powerLevelOverride.stateDefault = 50
        powerLevelOverride.usersDefault = 0
        powerLevelOverride.invite = 50
        parameters.powerLevelContentOverride = powerLevelOverride
        self.createRoom(parameters: parameters, roomAvatar: roomAvatar?.jpeg(.medium)) { result in
            completion(result)
        }
    }
    
    func createDirectRoom(_ ids: [String],
                          completion: @escaping (RoomCreateState) -> Void) {
        guard
            ids.count == 1,
            let userId = ids.first,
            !self.isDirectRoomExists(userId: userId)
        else {
            completion(.roomCreateError)
            return
        }
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = ids
        parameters.isDirect = true
        parameters.visibility = MXRoomDirectoryVisibility.private.identifier
        parameters.preset = MXRoomPreset.privateChat.identifier
        createRoom(parameters: parameters, completion: { result in
            completion(result)
        })
        self.objectChangePublisher.send()
    }
    
    func createRoom(parameters: MXRoomCreationParameters, roomAvatar: Data? = nil,
                    completion: @escaping (RoomCreateState) -> Void) {
        self.createRoom(parameters: parameters) { [weak self] response in
            switch response {
            case let .success(room):
                completion(.roomCreateSucces)
                guard let data = roomAvatar else {
                    return
                }

                self?.setRoomAvatar(data: data, for: room) { _ in
                    // TODO: Обработать case failure
                    //self?.closeScreen = true
                }
            case.failure:
                completion(.roomCreateError)
            }
        }
    }
    
    func createGroupRoom(_ info: ChatData, completion: @escaping (RoomCreateState) -> Void) {
        let parameters = MXRoomCreationParameters()
        parameters.inviteArray = info.contacts.map({ $0.mxId })
        parameters.isDirect = false
        parameters.name = info.title
        parameters.topic = info.description
        parameters.visibility = MXRoomDirectoryVisibility.private.identifier
        parameters.preset = MXRoomPreset.privateChat.identifier
        self.createRoom(parameters: parameters, roomAvatar: info.image?.jpeg(.medium), completion: { result in
            completion(result)
        })
    }
    
    
    
    func getRoomAvatarUrl(roomId: String) -> URL? {
        guard let room = getRoomInfo(roomId: roomId),
            let avatar = room.summary.avatar,
              let avatarUrl = MXURL(mxContentURI: avatar)?.contentURL(on: config.matrixURL) else { return nil }
        
        return avatarUrl
    }
    
    func getRoomInfo(roomId: String) -> MXRoom? {
        guard let room = matrixSession?.rooms.first(where: {
            $0.roomId == roomId
        }) else {
            return nil
        }
        return room
    }
    
    func setRoomName(
        name: String,
        roomId: String,
        completion: @escaping (MXResponse<Void>) -> Void
    ) {
        matrixService.matrixSession?.matrixRestClient?
            .setName(ofRoom: roomId, name: name, completion: completion)
    }
    
    func setRoomTopic(
        topic: String,
        roomId: String,
        completion: @escaping (MXResponse<Void>) -> Void
    ) {
        matrixService.matrixSession?.matrixRestClient?
            .setTopic(ofRoom: roomId, topic: topic, completion: completion)
    }

	func isDirectRoomExists(userId: String) -> Bool {
		matrixService.isDirectRoomExists(userId: userId)
	}

    func isRoomEncrypted(roomId: String) -> Bool {
        matrixService.isRoomEncrypted(roomId: roomId) { _ in
        }
        return true
    }

    func isRoomPublic(roomId: String, completion: @escaping (Bool?) -> Void) {
        matrixService.isRoomPublic(roomId: roomId) { value in
           completion(value)
        }
    }

    func setRoomState(roomId: String,
                      isPublic: Bool,
                      completion: @escaping (MXResponse<Void>?) -> Void) {
        matrixService.setRoomState(roomId: roomId,
                                   isPublic: isPublic) { _ in
        }
    }

    func setJoinRule(roomId: String, isPublic: Bool,
                     completion: @escaping (MXResponse<Void>?) -> Void) {
        matrixService.setJoinRule(roomId: roomId,
                                  isPublic: isPublic) { _ in
        }
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
    
    func sendText(_ roomId: String,
                  _ text: String,
                  completion: @escaping (Result <String?, MXErrors>) -> Void) {
        matrixService.sendText(roomId,
                               text, completion: completion)
    }
    
    func markAllAsRead(roomId: String) {
        matrixService.markAllAsRead(roomId: roomId)
    }
    
    func edit(roomId: String, text: String,
              eventId: String) {
        matrixService.edit(roomId: roomId, text: text, eventId: eventId)
    }

    func removeReaction(roomId: String, text: String,
              eventId: String,
                        completion: @escaping (Result <String?, MXErrors>) -> Void) {
        matrixService.removeReaction(roomId: roomId,
                                     text: text,
                                     eventId: eventId) { result in
            completion(result)
        }
    }

    func react(eventId: String, roomId: String, emoji: String) {
        matrixSession?.aggregations.addReaction(
            emoji,
            forEvent: eventId,
            inRoom: roomId,
            success: {
                debugPrint("emotions success")
            }, failure: { error in
                debugPrint("emotions error \(error)")
            })
    }
    

    func redact(roomId: String,
                eventId: String, reason: String?) {
        
        matrixService.redact(roomId: roomId, eventId: eventId, reason: reason)
    }

    func sendLocation(roomId: String,
                      location: LocationData?,
                      completion: @escaping (Result <String?, MXErrors>) -> Void) {
        matrixService.sendLocation(roomId: roomId,
                                   location: location, completion: completion)
    }

    func setRoomAvatar(data: Data, roomId: String, completion: @escaping EmptyResultBlock) {
        guard let room = getRoomInfo(roomId: roomId) else {
            completion(.failure)
            return
        }
        setRoomAvatar(data: data, for: room, completion: completion)
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
    
    func getUserAvatar(
        avatarString: String,
        completion: @escaping EmptyFailureBlock<UIImage>
    ) {
        let homeServer = self.config.matrixURL
        if let url = MXURL(mxContentURI: avatarString)?.contentURL(on: homeServer) {
            self.cache.loadImage(atUrl: url) { _, image in
                guard let i = image else { return }
                completion(.success(i))
            }
        }
    }
    
    func avatarUrlForUser(_ userId: String, completion: @escaping (URL?) -> Void) {
        matrixService.avatarUrlForUser(userId) { result in
            completion(result)
        }
    }
    
    func getRoomMembers(
        roomId: String,
        completion: @escaping EmptyFailureBlock<MXRoomMembers>
    ) {
        let matrixRoom = matrixService.rooms.first(where: { $0.room.roomId == roomId })?.room
        guard let room = matrixRoom else { completion(.failure); return }
         
        room.liveTimeline { timeline in
            guard let state = timeline?.state else { completion(.failure); return }
            completion(.success(state.members))
        }
    }
    
    func enableEncryptionWithAlgorithm(roomId: String) {
        matrixService.enableEncryptionWithAlgorithm(roomId: roomId) { result in
            debugPrint(result)
        }
    }
    
    func sendReply(_ event: RoomEvent,
                   _ text: String) {
        guard !text.isEmpty else { return }
        var rootMessage = ""
        if text.contains(">") {
            let startIndex = text.index(text.lastIndex(of: ">") ?? text.startIndex, offsetBy: 2)
            rootMessage = String(text.suffix(from: startIndex))
            let rootMessageAll = rootMessage.split(separator: "\n")
            rootMessage = String(rootMessageAll[0])
        } else {
            rootMessage = text
        }
        let customParameters: [String: Any] = [
            "m.reply_to": ReplyCustomContent(
                rootUserId: event.sender,
                rootMessage: rootMessage,
                rootEventId: event.eventId,
                rootLink: ""
            ).content
        ]
        matrixService.sendReply(rootMessage,
                                event.roomId,
                                event.eventId,
                                customParameters) { result in
            print("slaslsallas  \(result)")
            
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

			self?.matrixService.setUser(avatarUrl: avatarUrl) { [weak self] result in

				guard let self = self,
                    case .success = result  else { completion(nil); return }

                let homeServer = self.config.matrixURL
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
    
    func updateUserPowerLevel(
        userId: String,
        roomId: String,
        powerLevel: Int,
        completion: @escaping EmptyResultBlock
    ) {
        matrixService.updateUserPowerLevel(
            userId: userId,
            roomId: roomId,
            powerLevel: powerLevel,
            completion: completion
        )
    }
    
    func updateUsersPowerLevel(
        userIds: [String],
        roomId: String,
        powerLevel: Int,
        completion: @escaping EmptyResultBlock
    ) {
        matrixService.updateUsersPowerLevel(userIds: userIds,
                                            roomId: roomId,
                                            powerLevel: powerLevel,
                                            completion: completion)
    }
    
    func getPublicRooms(filter: String,
                        onTapCell: @escaping (MatrixChannel) -> Void,
                        completion: @escaping ([MatrixChannel]) -> Void) {
        matrixService.getPublicRooms(filter: filter) { value in
            switch value {
            case .success(let success):
                guard let publicRooms = success else {
                    completion([])
                    return
                }
                let channels = publicRooms.map {
                    let room = MatrixChannel(roomId: $0.roomId,
                                             name: $0.name,
                                             numJoinedMembers: $0.numJoinedMembers,
                                             avatarUrl: $0.avatarUrl ?? "",
                                             isJoined: false, onTap: { room in
                        onTapCell(room)
                    })
                    return room
                }
                completion(channels)
            case .failure(let failure):
                completion([])
            }
        }
    }
    
	// MARK: - Pusher
	func createPusher(pushToken: Data, completion: @escaping (Bool) -> Void) {
		matrixService.createPusher(pushToken: pushToken, completion: completion)
	}
    
    func deletePusher(appId: String, pushToken: Data, completion: @escaping (Bool) -> Void) {
        matrixService.deletePusher(appId: appId, pushToken: pushToken, completion: completion)
    }
    
    func createVoipPusher(pushToken: Data, completion: @escaping (Bool) -> Void) {
        matrixService.createVoipPusher(pushToken: pushToken, completion: completion)
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
