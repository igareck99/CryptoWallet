import Combine
import Foundation
import MatrixSDK

protocol MatrixServiceProtocol {

	var objectChangePublisher: ObservableObjectPublisher { get }
	var loginStatePublisher: Published<MatrixState>.Publisher { get }
	var devicesPublisher: Published<[MXDevice]>.Publisher { get }
	var rooms: [AuraRoom] { get }
    var auraRooms: [AuraRoomData] { get }
	var matrixSession: MXSession? { get }
    var auraNoEventsRooms: [AuraRoomData] { get }

	func closeSessionAndClearData()

	// MARK: - Updaters
	func updateClient(with homeServer: URL)
	func updateState(with state: MatrixState)
	func updateService(credentials: MXCredentials)
	func updateUnkownDeviceWarn(isEnabled: Bool)

	// MARK: - Session
	func initializeSessionStore(completion: @escaping (EmptyResult) -> Void)
	func startSession(completion: @escaping (Result<MatrixState, MXErrors>) -> Void)
    func loginByJWT(token: String, deviceId: String, userId: String, homeServer: URL, completion: @escaping LoginCompletion)
	func login(userId: String, password: String, homeServer: URL, completion: @escaping LoginCompletion)
	func logout(completion: @escaping (Result<MatrixState, Error>) -> Void)

	// MARK: - Devices
	func getDeviceSession(by deviceId: String, completion: @escaping (EmptyResult) -> Void)
	func removeDevice(by deviceId: String, completion: @escaping (EmptyResult) -> Void)
	func remove(userDevices: [MXDevice], completion: @escaping (EmptyResult) -> Void)

	// MARK: - Remove device by ID
	func getDevicesWithActiveSessions(completion: @escaping (Result<[MXDevice], Error>) -> Void)

	// MARK: - Rooms
    func isRoomEncrypted(roomId: String, completion: @escaping (Bool?) -> Void)
    func isRoomPublic(roomId: String, completion: @escaping (Bool?) -> Void)
    func setRoomState(roomId: String,
                      isPublic: Bool,
                      completion: @escaping (MXResponse<Void>?) -> Void)
    func setJoinRule(roomId: String, isPublic: Bool,
                     completion: @escaping (MXResponse<Void>?) -> Void)
	func startListeningForRoomEvents()
	func createRoom(parameters: MXRoomCreationParameters, completion: @escaping (MXResponse<MXRoom>) -> Void)
	func uploadData(data: Data, for room: MXRoom, completion: @escaping GenericBlock<URL?>)
	func leaveRoom(roomId: String, completion: @escaping (MXResponse<Void>) -> Void)
	func joinRoom(roomId: String, completion: @escaping (MXResponse<MXRoom>) -> Void)
	func isDirectRoomExists(userId: String) -> Bool
	func placeVoiceCall(roomId: String, completion: @escaping (Result<MXCall, MXErrors>) -> Void)
	func placeVideoCall(roomId: String, completion: @escaping (Result<MXCall, MXErrors>) -> Void)
    func uploadImage(for roomId: String, image: UIImage,
                     completion: @escaping (Result <String?, MXErrors>) -> Void)
    func uploadFile(for roomId: String, url: URL,
                    completion: @escaping (Result <String?, MXErrors>) -> Void)
    func uploadContact(for roomId: String, contact: Contact,
                       completion: @escaping (Result <String?, MXErrors>) -> Void)
    func uploadVoiceMessage(for roomId: String,
                            url: URL,
                            duration: UInt,
                            completion: @escaping (Result <String?, MXErrors>) -> Void)
    func uploadVideoMessage(for roomId: String,
                            url: URL,
                            thumbnail: MXImage?,
                            completion: @escaping (Result <String?, MXErrors>) -> Void)
    func enableEncryptionWithAlgorithm(roomId: String,
                                       completion: @escaping (Result <String?, MXErrors>) -> Void)
    func getPublicRooms(filter: String,
                        completion: @escaping  (Result <[MXPublicRoom]?, MXErrors>) -> Void)
    func sendLocation(roomId: String,
                      location: LocationData?,
                      completion: @escaping (Result <String?, MXErrors>) -> Void)
    func markAllAsRead(roomId: String)
    func edit(roomId: String, text: String,
              eventId: String)
    func redact(roomId: String,
                eventId: String, reason: String?)

	// MARK: - Users
	func currentlyActive(_ userId: String) -> Bool
	func fromCurrentSender(_ userId: String) -> Bool
	func getUser(_ id: String) -> MXUser?
	func getUserId() -> String
	func getDisplayName() -> String
	func getStatus() -> String
    func avatarUrlForUser(_ userId: String, completion: @escaping (URL?) -> Void)
	func getAvatarUrl(completion: @escaping (String) -> Void)
	func setDisplayName(_ displayName: String, completion: @escaping VoidBlock)
	func setStatus(_ status: String, completion: @escaping VoidBlock)
	func setUser(avatarUrl: String, completion: @escaping EmptyResultBlock)
	func uploadUser(data: Data, completion: @escaping GenericBlock<String?>)
	func allUsers() -> [MXUser]
	func searchUser(_ id: String, completion: @escaping GenericBlock<String?>)
    func inviteUser(userId: String, roomId: String, completion: @escaping EmptyResultBlock)
    func kickUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock)
    func banUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock)
    func unbanUser(userId: String, roomId: String, completion: @escaping EmptyResultBlock)
    func leaveRoom(roomId: String, completion: @escaping EmptyResultBlock)
    func updateUserPowerLevel(
        userId: String,
        roomId: String,
        powerLevel: Int,
        completion: @escaping EmptyResultBlock
    )
    func updateUsersPowerLevel(
        userIds: [String],
        roomId: String,
        powerLevel: Int,
        completion: @escaping EmptyResultBlock
    )
    func sendText(_ roomId: String,
                  _ text: String,
                  completion: @escaping (Result <String?, MXErrors>) -> Void)
    func sendReply(_ text: String,
                   _ roomId: String,
                   _ eventId: String,
                   _ customParameters: [String : Any],
                   completion: @escaping (Result <String?, MXErrors>) -> Void)

	// MARK: - Pagination
	func paginate(room: AuraRoom, event: MXEvent)

	// MARK: - Pusher
	func createPusher(pushToken: Data, completion: @escaping GenericBlock<Bool>)
    func deletePusher(appId: String, pushToken: Data, completion: @escaping GenericBlock<Bool>)
    func createVoipPusher(pushToken: Data, completion: @escaping GenericBlock<Bool>)

	// MARK: - Fetcher
	func configureFetcher()
}
