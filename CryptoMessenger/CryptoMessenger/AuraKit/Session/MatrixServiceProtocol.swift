import Combine
import Foundation
import MatrixSDK

protocol MatrixServiceProtocol {

	var objectChangePublisher: ObservableObjectPublisher { get }
	var loginStatePublisher: Published<MatrixState>.Publisher { get }
	var devicesPublisher: Published<[MXDevice]>.Publisher { get }
	var rooms: [AuraRoom] { get }
	var matrixSession: MXSession? { get }

	// MARK: - Updaters
	func updateClient(with homeServer: URL)
	func updateState(with state: MatrixState)
	func updateUser(credentials: MXCredentials)
	func updateService(credentials: MXCredentials)
	func updateUnkownDeviceWarn(isEnabled: Bool)

	// MARK: - Session
	func initializeSessionStore(completion: @escaping (EmptyResult) -> Void)
	func startSession(completion: @escaping (Result<MatrixState, MXErrors>) -> Void)
	func login(userId: String, password: String, homeServer: URL, completion: @escaping LoginCompletion)
	func logout(completion: @escaping (Result<MatrixState, Error>) -> Void)

	// MARK: - Devices
	func getDeviceSession(by deviceId: String, completion: @escaping (EmptyResult) -> Void)
	func removeDevice(by deviceId: String, completion: @escaping (EmptyResult) -> Void)
	func remove(userDevices: [MXDevice])

	// MARK: - Remove device by ID
	func getDevicesWithActiveSessions(completion: @escaping (Result<[MXDevice], Error>) -> Void)

	// MARK: - Rooms
	func startListeningForRoomEvents()
	func createRoom(parameters: MXRoomCreationParameters, completion: @escaping (MXResponse<MXRoom>) -> Void)
	func uploadData(data: Data, for room: MXRoom, completion: @escaping GenericBlock<URL?>)
	func leaveRoom(roomId: String, completion: @escaping (MXResponse<Void>) -> Void)
	func joinRoom(roomId: String, completion: @escaping (MXResponse<MXRoom>) -> Void)
	func isDirectRoomExists(userId: String) -> Bool
	func placeVoiceCall(roomId: String, completion: @escaping (Result<MXCall, MXErrors>) -> Void)
    func uploadImage(for roomId: String, image: UIImage,
                     completion: @escaping (Result <String?, MXErrors>) -> Void)
    func uploadFile(for roomId: String, url: URL,
                    completion: @escaping (Result <String?, MXErrors>) -> Void)
    func uploadContact(for roomId: String, contact: Contact,
                       completion: @escaping (Result <String?, MXErrors>) -> Void)

	// MARK: - Users
	func currentlyActive(_ userId: String) -> Bool
	func fromCurrentSender(_ userId: String) -> Bool
	func getUser(_ id: String) -> MXUser?
	func getUserId() -> String
	func getDisplayName() -> String
	func getStatus() -> String
	func getAvatarUrl() -> String
	func setDisplayName(_ displayName: String, completion: @escaping VoidBlock)
	func setStatus(_ status: String, completion: @escaping VoidBlock)
	func setUser(avatarUrl: String, completion: @escaping EmptyResultBlock)
	func uploadUser(data: Data, completion: @escaping GenericBlock<String?>)
	func allUsers() -> [MXUser]
	func searchUser(_ id: String, completion: @escaping GenericBlock<String?>)

	// MARK: - Pagination
	func paginate(room: AuraRoom, event: MXEvent)

	// MARK: - Pusher
	func createPusher(with pushToken: Data, completion: @escaping (Bool) -> Void)
	func deletePusher(with pushToken: Data, completion: @escaping (Bool) -> Void)
}