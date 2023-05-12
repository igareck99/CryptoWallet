import Combine
import MatrixSDK
// MARK: - AuraRoom

final class AuraRoom: ObservableObject {

    // MARK: - Internal Properties

    var room: MXRoom
    var isOnline = false
    var roomAvatar: URL?

    @Published var summary: RoomSummary
    @Published var eventCache: [MXEvent] = []

    var isDirect: Bool { room.isDirect }
    var messageType: MessageType {
        return eventCache.last?.messageType  ?? .text("")
    }
    
    var lastMessageEvent: MessageType {
        if summary.membership == .invite {
            let inviteEvent = eventCache.last {
                $0.type == kMXEventTypeStringRoomMember && $0.stateKey == room.mxSession.myUserId
            }
            guard let sender = inviteEvent?.sender else { return .text("") }
            return .text("Invitation to Chat 🤚")
        }
        let lastMessageEvent = eventCache.last { $0.type == kMXEventTypeStringRoomMessage }
        let callEvent = eventCache.last
        if callEvent?.type == "m.call.hangup" {
            return .call
        }
        return lastMessageEvent?.messageType ?? .text("")
    }

    // MARK: - Lifecycle

    init(
        _ room: MXRoom,
        config: ConfigType = Configuration.shared
    ) {
        self.room = room
        self.summary = RoomSummary(room.summary)
        if let avatar = room.summary.avatar {
            let homeServer = config.matrixURL
            roomAvatar = MXURL(mxContentURI: avatar)?.contentURL(on: homeServer)
        }
        let enumerator = room.enumeratorForStoredMessages // WithType(in: Self.displayedMessageTypes)
        let currentBatch = enumerator?.nextEventsBatch(200, threadId: nil) ?? []

        eventCache.append(contentsOf: currentBatch)
    }

    // MARK: - Internal Methods

    func add(event: MXEvent, direction: MXTimelineDirection, roomState: MXRoomState?) {
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
}
