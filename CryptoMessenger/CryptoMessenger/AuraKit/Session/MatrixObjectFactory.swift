import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol MatrixObjectFactoryProtocol {

	func makeRooms(
		mxRooms: [MXRoom]?,
		isRoomUserActive: @escaping (String) -> Bool
    ) -> [AuraRoom]

    func makeAuraRooms(
        mxRooms: [MXRoom]?,
        isMakeEvents: Bool,
        config: ConfigType,
        eventsFactory: RoomEventObjectFactoryProtocol,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [AuraRoomData]
}

struct MatrixObjectFactory {}

// MARK: - MatrixObjectFactoryProtocol

extension MatrixObjectFactory: MatrixObjectFactoryProtocol {

	func makeRooms(
		mxRooms: [MXRoom]?,
		isRoomUserActive: @escaping (String) -> Bool
	) -> [AuraRoom] {
		guard let matrixRooms = mxRooms else { return [] }
		let auraRooms: [AuraRoom] = matrixRooms
			.map { mxRoom in
				let room = AuraRoom(mxRoom)
				if mxRoom.isDirect {
					room.isOnline = isRoomUserActive(mxRoom.directUserId)
				}
				return room
			}
			.compactMap { $0 }
			.sorted { $0.summary.lastMessageDate > $1.summary.lastMessageDate }
		return auraRooms
	}

    func makeAuraRooms(
        mxRooms: [MXRoom]?,
        isMakeEvents: Bool,
        config: ConfigType,
        eventsFactory: RoomEventObjectFactoryProtocol,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [AuraRoomData] {
        guard let matrixRooms = mxRooms else { return [] }
        let auraRooms: [AuraRoomData] = matrixRooms
            .map { mxRoom in
                let roomId = mxRoom.roomId ?? ""
                var powerLevels = true
                var isAdmin = false
                // MARK: Async call !!!
                mxRoom.state { state in
                    powerLevels = state?.powerLevels?.eventsDefault == 50
                    isAdmin = state?.powerLevels?.powerLevelOfUser(withUserID: matrixUseCase.getUserId()) == 100
                }
                var roomAvatar: URL?
                let summary: RoomSummary
                if let rSummary = mxRoom.summary {
                    summary = RoomSummary(mxRoom.summary)
                } else {
                    summary = RoomSummary(MXRoomSummary())
                }
                if let avatarUrl: URL = MXURL(mxContentURI: summary.avatar)?.contentURL(on: config.matrixURL) {
                    roomAvatar = avatarUrl
                }
                let enumerator = mxRoom.enumeratorForStoredMessages
                let currentBatch = enumerator?.nextEventsBatch(50, threadId: nil) ?? []
                var messageType = MessageType.text("")
                let lastMessageEvent = currentBatch.last { $0.type == kMXEventTypeStringRoomMessage }
                if currentBatch.last?.type == "m.call.hangup" {
                    messageType = .call
                }
                var events: [RoomEvent] = []
                if isMakeEvents {
                    events = eventsFactory.makeChatHistoryRoomEvents(
                        eventCollections: EventCollection(currentBatch),
                        matrixUseCase: matrixUseCase
                    )
                }
                let unreadedEvents = summary.localUnreadEventCount
                messageType = lastMessageEvent?.messageType ?? MessageType.text("")
                let members = summary.membersCount
                let homeServer = config.matrixURL
                var roomName = summary.displayName
                if roomName.contains("others") && roomName.contains("&"),
                   let rName = roomName.split(separator: "&")[safe: 0] {
                    roomName = String(rName)
                }

                let room = AuraRoomData(
                    isChannel: powerLevels,
                    isAdmin: isAdmin,
                    isPinned: false,
//                    isOnline: isRoomUserActive(mxRoom.directUserId),
                    isOnline: false,
                    isDirect: mxRoom.isDirect,
                    unreadedEvents: Int(unreadedEvents),
                    lastMessage: messageType,
                    lastMessageTime: summary.lastMessageDate,
                    roomAvatar: roomAvatar,
                    roomName: roomName,
                    numberUsers: Int(members),
                    topic: summary.summary?.topic ?? "",
                    roomId: roomId,
                    roomEvents: events,
                    eventCollections: EventCollection(currentBatch),
                    participants: [], 
                    room: mxRoom
                )
                return room
            }
            .compactMap { $0 }
            .sorted { $0.lastMessageTime > $1.lastMessageTime }
        return auraRooms
    }
}
