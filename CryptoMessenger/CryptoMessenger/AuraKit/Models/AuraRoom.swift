import Combine
import MatrixSDK

// swiftlint:disable all

// MARK: - RoomItem

struct RoomItem: Codable, Hashable {

    // MARK: - Internal Properties

    let roomId: String
    let displayName: String
    let messageDate: UInt64

    // MARK: - Lifecycle

    init(room: MXRoom) {
        self.roomId = room.summary.roomId
        self.displayName = room.summary.displayName ?? ""
		self.messageDate = room.summary.lastMessage.originServerTs
    }

    // MARK: - Static Methods

    static func == (lhs: RoomItem, rhs: RoomItem) -> Bool {
        lhs.displayName == rhs.displayName && lhs.roomId == rhs.roomId
    }
}

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
        if summary.summary?.membership == .invite {
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


    // TODO: - Will be Deprecated

    func updateEvents(eventId: String?) {
        guard let event = self.events().renderableEvents.first(where: { eventId == $0.eventId
        }) else { return }
        if !self.eventCache.contains(event) {
            self.eventCache.append(event)
        }
        self.objectWillChange.send()
    }
    
    func sendReply(_ event: RoomEvent,
                   _room: AuraRoomData,
                   _ text: String) {
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
        
    }

    func reply(text: String, eventId: String) {
        guard !text.isEmpty else { return }
        var localEcho: MXEvent?
        guard let event = events().renderableEvents.first(where: { eventId == $0.eventId }) else {
            return
        }
        var rootMessage = ""
        if event.text.contains(">") {
            let startIndex = event.text.index(event.text.lastIndex(of: ">") ?? event.text.startIndex, offsetBy: 2)
            rootMessage = String(event.text.suffix(from: startIndex))
            let rootMessageAll = rootMessage.split(separator: "\n")
            rootMessage = String(rootMessageAll[0])
        } else {
            rootMessage = event.text
        }
		let customParameters: [String: Any] = [
			"m.reply_to": ReplyCustomContent(
				rootUserId: event.sender,
				rootMessage: rootMessage,
				rootEventId: event.eventId,
				rootLink: ""
			).content
		]
        if let longitude = event.content["longitude"],
           let latitude = event.content["latitude"] {
            event.wireContent["geo_uri"] = "geo:\(latitude),\(longitude)"
        }
        room.sendReply(to: event,
                       textMessage: text,
                       formattedTextMessage: nil,
                       stringLocalizations: nil,
                       localEcho: &localEcho,
                       customParameters: customParameters) { response in
            self.objectWillChange.send()
        }
    }
}

// MARK: - AuraRoom (Identifiable)

extension AuraRoom: Identifiable {
    var id: ObjectIdentifier { room.id }
}
