import Combine
import MatrixSDK

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
        self.messageDate = room.summary.lastMessageOriginServerTs
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
    var messageType: MessageType { room.summary.lastMessageEvent?.messageType ?? .text("") }
    var lastMessage: String {
        if summary.membership == .invite {
            let inviteEvent = eventCache.last {
                $0.type == kMXEventTypeStringRoomMember && $0.stateKey == room.mxSession.myUserId
            }
            guard let sender = inviteEvent?.sender else { return "" }
            return "Invitation from: \(sender)"
        }
        let lastMessageEvent = eventCache.last { $0.type == kMXEventTypeStringRoomMessage }
        ?? room.summary.lastMessageEvent
        if lastMessageEvent?.isEdit() ?? false {
            let newContent = lastMessageEvent?.content["m.new_content"] as? NSDictionary
            return newContent?["body"] as? String ?? ""
        } else if let lastMessage = lastMessageEvent?.content["body"] as? String {
            return lastMessage
        } else if let event = room.outgoingMessages().last(where: { $0.type == kMXEventTypeStringRoomMessage }) {
            return event.content["body"] as? String ?? ""
        } else {
            return ""
        }
    }

    // MARK: - Lifecycle

    init(_ room: MXRoom) {
        self.room = room
        self.summary = RoomSummary(room.summary)
        if let avatar = room.summary.avatar {
            let homeServer = Bundle.main.object(for: .matrixURL).asURL()
            roomAvatar = MXURL(mxContentURI: avatar)?.contentURL(on: homeServer)
        }
        let enumerator = room.enumeratorForStoredMessages // WithType(in: Self.displayedMessageTypes)
        let currentBatch = enumerator?.nextEventsBatch(200) ?? []

        eventCache.append(contentsOf: currentBatch)
    }

    // MARK: - Internal Methods

    func add(event: MXEvent, direction: MXTimelineDirection, roomState: MXRoomState?) {
        switch direction {
        case .backwards:
            eventCache.insert(event, at: 0)
        case .forwards:
            eventCache.append(event)
        }
    }

    func events() -> EventCollection {
        EventCollection(eventCache + room.outgoingMessages())
    }

    func react(toEventId eventId: String, emoji: String) {
        // swiftlint:disable:next force_try
        let content = try! ReactionEvent(eventId: eventId, key: emoji).encodeContent()

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

    func sendImage(_ image: UIImage) {
        let fixedImage = image.fixOrientation()
        guard let imageData = fixedImage.jpeg(.medium) else { return }

        var localEcho: MXEvent?
        room.sendImage(
            data: imageData,
            size: image.size,
            mimeType: "image/jpeg",
            thumbnail: image,
            localEcho: &localEcho
        ) { _ in
            self.objectWillChange.send()
        }
    }

    func sendFile(_ url: URL) {
        var localEcho: MXEvent?
        room.sendFile(
            localURL: url,
            mimeType: "file/pdf",
            localEcho: &localEcho
        ) { _ in
            self.objectWillChange.send()
        }
    }

    func sendContact(_ contact: Contact) {
        var localEcho: MXEvent?

        var content: [String: Any] = [:]
        content[.messageType] = MXEventCustomEvent.contactInfo.identifier
        content[.name] = contact.name
        content[.phone] = contact.phone
        content[.avatar] = contact.avatar?.absoluteString ?? ""

        room.sendMessage(withContent: content, localEcho: &localEcho) { _ in
            self.objectWillChange.send()
        }
    }

    func reply(text: String, eventId: String) {
        guard let event = events().renderableEvents.first(where: { eventId == $0.eventId }) else { return }
        var localEcho: MXEvent?
        room.sendReply(to: event, textMessage: text, formattedTextMessage: nil, stringLocalizations: nil, localEcho: &localEcho) { _ in
            self.objectWillChange.send()
        }
    }

    func markAllAsRead() {
        room.markAllAsRead()
    }

    func removeOutgoingMessage(_ eventId: String) {
        room.removeOutgoingMessage(eventId)
        objectWillChange.send()
    }

    func removeOutgoingMessage(_ event: MXEvent) {
        room.removeOutgoingMessage(event.eventId)
        objectWillChange.send()
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
