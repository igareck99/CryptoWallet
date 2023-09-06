import Combine
import Foundation
import MatrixSDK

protocol MatrixUseCaseProtocol {

	var objectChangePublisher: ObservableObjectPublisher { get }
	var loginStatePublisher: Published<MatrixState>.Publisher { get }
	var devicesPublisher: Published<[MXDevice]>.Publisher { get }
	var rooms: [AuraRoom] { get }
    var auraRooms: [AuraRoomData] { get }
    var auraNoEventsRooms: [AuraRoomData] { get }

	// MARK: - Session
	var matrixSession: MXSession? { get }

    func updateCredentialsIfAvailable()

    func loginByJWT(
        token: String,
        deviceId: String,
        userId: String,
        homeServer: URL,
        completion: @escaping EmptyResultBlock
    )

	func closeSession()
    func serverSyncWithServerTimeout()

	// MARK: - Rooms
    func createChannel(name: String,
                       topic: String,
                       channelType: ChannelType,
                       roomAvatar: UIImage?,
                       completion: @escaping (RoomCreateState) -> Void)
    func createDirectRoom(_ ids: [String],
                          completion: @escaping (RoomCreateState) -> Void)
    func createRoom(parameters: MXRoomCreationParameters, roomAvatar: Data?,
                    completion: @escaping (RoomCreateState) -> Void)
    func createGroupRoom(_ info: ChatData, completion: @escaping (RoomCreateState) -> Void)
    func getRoomAvatarUrl(roomId: String) -> URL?
    func getUserAvatar(avatarString: String, completion: @escaping EmptyFailureBlock<UIImage>)
    func avatarUrlForUser(_ userId: String, completion: @escaping (URL?) -> Void)
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
    func getPublicRooms(filter: String,
                        onTapCell: @escaping (MatrixChannel) -> Void,
                        completion: @escaping ([MatrixChannel]) -> Void)
    func sendText(_ roomId: String,
                  _ text: String,
                  completion: @escaping (Result <String?, MXErrors>) -> Void)
    func sendLocation(roomId: String,
                      location: LocationData?,
                      completion: @escaping (Result <String?, MXErrors>) -> Void)
    func markAllAsRead(roomId: String)
    func edit(roomId: String, text: String,
              eventId: String)
    func react(eventId: String, roomId: String, emoji: String)
    func redact(roomId: String,
                eventId: String, reason: String?)
    func sendReply(_ event: RoomEvent,
                   _ text: String,
                   completion: @escaping (Result <String?, MXErrors>) -> Void)
    func removeReaction(roomId: String, text: String,
                        eventId: String,
                        completion: @escaping (Result <String?, MXErrors>) -> Void)
    
    // MARK: - Pusher
    func createPusher(pushToken: Data, completion: @escaping (Bool) -> Void)
    func deletePusher(appId: String, pushToken: Data, completion: @escaping (Bool) -> Void)
    func createVoipPusher(pushToken: Data, completion: @escaping (Bool) -> Void)

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
