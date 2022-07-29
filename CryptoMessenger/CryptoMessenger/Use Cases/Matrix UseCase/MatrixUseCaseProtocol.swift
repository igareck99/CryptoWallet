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

	func closeSession()

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
