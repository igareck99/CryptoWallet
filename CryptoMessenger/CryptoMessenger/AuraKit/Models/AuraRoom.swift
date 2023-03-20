import Combine

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
        self.displayName = room.summary.displayname ?? ""
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

	// TODO: Закоментировал, т.к. этот код нигде не используется, если в нем не возникнет необходимости, то удалим
//    var lastMessage: String {
//        if summary.membership == .invite {
//            let inviteEvent = eventCache.last {
//                $0.type == kMXEventTypeStringRoomMember && $0.stateKey == room.mxSession.myUserId
//            }
//            guard let sender = inviteEvent?.sender else { return "" }
//            return "Invitation from: \(sender)"
//        }
//		let lastMessageEvent = eventCache.last { $0.type == kMXEventTypeStringRoomMessage }
//        if lastMessageEvent?.isEdit() ?? false {
//            let newContent = lastMessageEvent?.content["m.new_content"] as? NSDictionary
//            return newContent?["body"] as? String ?? ""
//        } else if let lastMessage = lastMessageEvent?.content["body"] as? String {
//            return lastMessage
//        } else if let event = room.outgoingMessages().last(where: { $0.type == kMXEventTypeStringRoomMessage }) {
//            return event.content["body"] as? String ?? ""
//        } else {
//            return ""
//        }
//    }
    
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

    func react(toEventId eventId: String, emoji: String) {
        // swiftlint:disable:next force_try
		guard
			let content = try? ReactionEvent(eventId: eventId, key: emoji).encodeContent()
		else {
			return
		}

        // room.outgoingMessages() will change
        var localEcho: MXEvent?
        room.sendEvent(.reaction, content: content, localEcho: &localEcho) { _ in
            self.objectWillChange.send()    // localEcho.sentState has(!) changed
        }
    }

    func edit(text: String, eventId: String) {
        guard !text.isEmpty else { return }

        var localEcho: MXEvent?
        // swiftlint:disable:next force_try
        let content = try! EditEvent(eventId: eventId, text: text).encodeContent()
        // TODO: Use localEcho to show sent message until it actually comes back
        room.sendMessage(withContent: content, localEcho: &localEcho) { _ in }
    }
    
    func sendLocation(location: LocationData?) {
        guard let unwrappedLocation = location else { return }
        var localEcho: MXEvent?
        do {
            let content = try LocationEvent(location: unwrappedLocation).encodeContent()
            room.sendMessage(withContent: content, localEcho: &localEcho) { _ in }
        } catch {
            debugPrint("Error create LocationEvent")
        }
    }

    func redact(eventId: String, reason: String?) {
        room.redactEvent(eventId, reason: reason) { _ in }
    }

    func sendText(_ text: String) {
        guard !text.isEmpty else { return }
        var localEcho: MXEvent?
        room.sendTextMessage(text, localEcho: &localEcho) { _ in
            self.objectWillChange.send()
        }
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

    func markAllAsRead() {
        room.markAllAsRead()
    }

    func removeOutgoingMessage(_ eventId: String) {
        guard let event = events().renderableEvents.first(where: { eventId == $0.eventId }) else { return }
        removeOutgoingMessage(event)
        self.objectWillChange.send()
    }

    func removeOutgoingMessage(_ event: MXEvent) {
        room.removeOutgoingMessage(event.eventId)
        self.objectWillChange.send()
    }
}

// MARK: - AuraRoom (Identifiable)

extension AuraRoom: Identifiable {
    var id: ObjectIdentifier { room.id }
}

// MARK: - UIImage ()

extension UIImage {

    // MARK: - JPEGQuality

    enum JPEGQuality: CGFloat {

        // MARK: - Types

        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }

    // MARK: - Internal Methods

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

// MARK: - ReplyCustomContent

struct ReplyCustomContent: Codable {

    // MARK: - Internal Properties

    var rootUserId: String = "root_user_id"
    var rootMessage: String = "root_message"
    var rootEventId: String = "root_event_id"
    var rootLink: String = "root_link"
    var content: [String: Any] {
            return ["root_user_id": rootUserId,
                    "root_message": rootMessage,
                    "root_event_id": rootEventId,
                    "root_link": rootLink]
        }
}
