import Combine
import MatrixSDK

// MARK: - AuraRoom

final class AuraRoom: ObservableObject {
    @Published var summary: RoomSummary
    @Published var eventCache: [MXEvent] = []
    let config: ConfigType
    let room: MXRoom
    var isOnline = false

    var roomId: String {
        room.roomId
    }

    var roomAvatar: URL? {
        let avatarUrlStr: String = room.summary?.avatar ?? ""
        let homeServer = config.matrixURL
        return MXURL(mxContentURI: avatarUrlStr)?.contentURL(on: homeServer)
    }

    var isDirect: Bool {
        room.isDirect
    }

    var messageType: MessageType {
        eventCache.last?.messageType ?? .text("")
	}

    var lastMessageEvent: MessageType {
        if summary.summary?.membership == .invite {
            let inviteEvent = eventCache.last {
                $0.type == kMXEventTypeStringRoomMember && $0.stateKey == room.mxSession.myUserId
            }
            guard inviteEvent?.sender != nil else { return .text("") }
            return .text("Invitation to Chat 🤚")
        }
        let lastMessageEvent = eventCache.last {
            $0.type == kMXEventTypeStringRoomMessage
        }
        let callEvent = eventCache.last
        if callEvent?.type == "m.call.hangup" {
            return .call
        }
        return lastMessageEvent?.messageType ?? .text("")
    }

    init(
        _ room: MXRoom,
        config: ConfigType = Configuration.shared
    ) {
        self.room = room
        self.config = config
        self.summary = RoomSummary(room.summary)
        let enumerator = room.enumeratorForStoredMessages // WithType(in: Self.displayedMessageTypes)
		let currentBatch = enumerator?.nextEventsBatch(250, threadId: nil) ?? []
        eventCache.append(contentsOf: currentBatch)
    }

    // MARK: - Internal Methods

    func add(
        event: MXEvent,
        direction: MXTimelineDirection,
        roomState: MXRoomState?
    ) {
        switch direction {
        case .backwards:
            eventCache.insert(event, at: 0)
        case .forwards:
            eventCache.append(event)
		default:
			break
        }
    }

    func events() -> EventCollection {
        if !room.outgoingMessages().isEmpty {
            for item in room.outgoingMessages() {
                if !eventCache.contains(item) {
                    eventCache.append(item)
                }
            }
        }
        return EventCollection(eventCache)
    }

    func updateEvents(eventId: String?) {
        guard let event = self.events().renderableEvents.first(
            where: { eventId == $0.eventId }
        ) else { return }
        if !self.eventCache.contains(event) {
            self.eventCache.append(event)
        }
        self.objectWillChange.send()
    }
}

extension AuraRoom: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(roomId)
    }

    static func == (lhs: AuraRoom, rhs: AuraRoom) -> Bool {
        lhs.roomId == rhs.roomId
    }
}
