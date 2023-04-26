import Combine
import Foundation

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

	func closeSession()
    func serverSyncWithServerTimeout()

	// MARK: - Rooms
    func getRoomAvatarUrl(roomId: String) -> URL?
    func getRoomInfo(roomId: String) -> MXRoom?
	func isDirectRoomExists(userId: String) -> Bool
    func isRoomEncrypted(roomId: String) -> Bool
	func leaveRoom(roomId: String, completion: @escaping (MXResponse<Void>) -> Void)
	func joinRoom(roomId: String, completion: @escaping (MXResponse<MXRoom>) -> Void)
	func createRoom(parameters: MXRoomCreationParameters, completion: @escaping (MXResponse<MXRoom>) -> Void)
	func uploadData(data: Data, for room: MXRoom, completion: @escaping GenericBlock<URL?>)
    func setRoomAvatar(data: Data, roomId: String, completion: @escaping EmptyResultBlock)
	func setRoomAvatar(data: Data, for room: MXRoom, completion: @escaping EmptyResultBlock)
    func getRoomState(roomId: String, completion: @escaping EmptyFailureBlock<MXRoomState>)
    func getRoomMembers(roomId: String, completion: @escaping EmptyFailureBlock<MXRoomMembers>)
    func setRoomName(name: String, roomId: String, completion: @escaping (MXResponse<Void>) -> Void)
    func setRoomTopic(topic: String, roomId: String, completion: @escaping (MXResponse<Void>) -> Void)
    func enableEncryptionWithAlgorithm(roomId: String)
    func isRoomPublic(roomId: String, completion: @escaping (Bool?) -> Void)
    func setRoomState(roomId: String,
                      isPublic: Bool,
                      completion: @escaping (MXResponse<Void>?) -> Void)
    func setJoinRule(roomId: String, isPublic: Bool,
                     completion: @escaping (MXResponse<Void>?) -> Void)
    func getPublicRooms(filter: String, completion: @escaping ([MatrixChannel]) -> Void)

	// MARK: - Pusher
	func createPusher(with pushToken: Data, completion: @escaping (Bool) -> Void)
    func deletePusher(with pushToken: Data, completion: @escaping (Bool) -> Void)

	// MARK: - Users
	func getUserId() -> String
	func getUser(_ id: String) -> MXUser?
	func allUsers() -> [MXUser]
	func fromCurrentSender(_ userId: String) -> Bool
	func searchUser(_ id: String, completion: @escaping GenericBlock<String?>)
	func getDisplayName() -> String
	func getStatus() -> String
	func getAvatarUrl(completion: @escaping (String) -> Void)
	func setDisplayName(_ displayName: String, completion: @escaping VoidBlock)
	func setStatus(_ status: String, completion: @escaping VoidBlock)
	func setUserAvatarUrl(_ data: Data, completion: @escaping GenericBlock<URL?>)

    func inviteUser(userId: String, roomId: String, completion: @escaping EmptyResultBlock)
    func kickUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock)
    func banUser(userId: String, roomId: String, reason: String, completion: @escaping EmptyResultBlock)
    func unbanUser(userId: String, roomId: String, completion: @escaping EmptyResultBlock)
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

	// MARK: - Device
	func getDevicesWithActiveSessions(completion: @escaping (Result<[MXDevice], Error>) -> Void)
	func logoutDevices(completion: @escaping EmptyResultBlock)
	func clearCredentials()
}
