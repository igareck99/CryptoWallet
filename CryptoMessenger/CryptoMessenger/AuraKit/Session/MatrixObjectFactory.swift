import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol MatrixObjectFactoryProtocol {

	func makeRooms(
		mxRooms: [MXRoom]?,
		isRoomUserActive: @escaping (String) -> Bool
    ) -> [AuraRoom]
    func makeAuraRooms(mxRooms: [MXRoom]?,
                       isMakeEvents: Bool,
                       config: ConfigType,
                       eventsFactory: RoomEventObjectFactoryProtocol,
                       matrixUseCase: MatrixUseCaseProtocol,
                       isRoomUserActive: @escaping (String) -> Bool) -> [AuraRoomData]
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
    
    func makeAuraRooms(mxRooms: [MXRoom]?,
                       isMakeEvents: Bool,
                       config: ConfigType,
                       eventsFactory: RoomEventObjectFactoryProtocol,
                       matrixUseCase: MatrixUseCaseProtocol,
                       isRoomUserActive: @escaping (String) -> Bool) -> [AuraRoomData] {
        guard let matrixRooms = mxRooms else { return [] }
        let auraRooms: [AuraRoomData] = matrixRooms
            .map { mxRoom in
                let roomId = mxRoom.roomId ?? ""
                var powerLevels = true
                var isAdmin = false
                mxRoom.state { state in
                    powerLevels = state?.powerLevels?.eventsDefault == 50
                    isAdmin = state?.powerLevels?.powerLevelOfUser(withUserID: matrixUseCase.getUserId()) == 100
                }
                
                let roomName = mxRoom.summary.displayName ?? ""
                var roomAvatar: URL?
                if let avatar = mxRoom.summary.avatar {
                    let homeServer = config.matrixURL
                    roomAvatar = MXURL(mxContentURI: avatar)?.contentURL(on: homeServer)
                }
                
                let enumerator = mxRoom.enumeratorForStoredMessages
                let currentBatch = enumerator?.nextEventsBatch(100, threadId: nil) ?? []
                var messageType = MessageType.text("")
                let lastMessageEvent = currentBatch.last { $0.type == kMXEventTypeStringRoomMessage }
                let callEvent = currentBatch.last
                if callEvent?.type == "m.call.hangup" {
                    messageType = .call
                }
                var events: [RoomEvent] = []
                if isMakeEvents {
                    events = eventsFactory.makeChatHistoryRoomEvents(eventCollections: EventCollection(currentBatch),
                                                                     matrixUseCase: matrixUseCase)
                }
                let summary = RoomSummary(mxRoom.summary)
                let unreadedEvents = summary.summary.localUnreadEventCount
                messageType = lastMessageEvent?.messageType ?? MessageType.text("")
                let room = AuraRoomData(isChannel: powerLevels,
                                        isAdmin: isAdmin,
                                        isPinned: false,
                                        //                                           isOnline: isRoomUserActive(mxRoom.directUserId),
                                        isOnline: false,
                                        isDirect: mxRoom.isDirect,
                                        unreadedEvents: Int(unreadedEvents),
                                        lastMessage: messageType,
                                        lastMessageTime: summary.lastMessageDate,
                                        roomAvatar: roomAvatar,
                                        roomName: roomName,
                                        numberUsers: Int(summary.summary.membersCount.joined),
                                        topic: summary.summary.topic ?? "",
                                        roomId: roomId,
                                        events: events,
                                        eventCollections: EventCollection(currentBatch))
                return room
            }
            .compactMap { $0 }
            .sorted { $0.lastMessageTime > $1.lastMessageTime }
        return auraRooms
    }
}
