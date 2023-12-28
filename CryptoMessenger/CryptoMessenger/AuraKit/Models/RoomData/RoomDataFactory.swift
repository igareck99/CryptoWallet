import Foundation
import MatrixSDK

// MARK: - MatrixObjectFactoryProtocol

protocol RoomEventObjectFactoryProtocol {

    func makeChatHistoryRoomEvents(
        eventCollections: EventCollection,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [RoomEvent]
}

struct RoomEventObjectFactory {}

// MARK: - RoomDataObjectFactory(RoomEventObjectFactoryFactoryProtocol)

extension RoomEventObjectFactory: RoomEventObjectFactoryProtocol {

    func makeChatHistoryRoomEvents(
        eventCollections: EventCollection,
        matrixUseCase: MatrixUseCaseProtocol
    ) -> [RoomEvent] {
        let roomEvents = eventCollections.wrapped
        var events = [RoomEvent]()
        if let currentEvent = roomEvents.first {
            events.append(
                RoomEvent(
                    eventId: UUID().uuidString,
                    roomId: currentEvent.roomId,
                    sender: "",
                    sentState: .sent,
                    eventType: .date(currentEvent.timestamp.dayOfWeekDayAndMonth),
                    shortDate: currentEvent.timestamp.hoursAndMinutes,
                    fullDate: currentEvent.timestamp.dayAndMonthAndYear,
                    isFromCurrentUser: false,
                    isReply: false,
                    reactions: [],
                    content: [:],
                    eventSubType: "",
                    eventDate: currentEvent.timestamp
                )
            )
        }

        roomEvents.enumerated().forEach { model in
            let event = model.element
            var url: URL?
            var reactions: [Reaction] = []
            let isFromCurrentUser = event.sender == matrixUseCase.getUserId()
            reactions = eventCollections.reactions(forEvent: event, currentUserId: matrixUseCase.getUserId())
            
            if let nextEvent = roomEvents[safe: model.offset + 1],
               nextEvent.timestamp.dayAndMonthAndYear != event.timestamp.dayAndMonthAndYear {
                events.append(
                    RoomEvent(
                        eventId: UUID().uuidString,
                        roomId: event.roomId,
                        sender: "",
                        sentState: .sent,
                        eventType: .date(event.timestamp.dayOfWeekDayAndMonth),
                        shortDate: event.timestamp.hoursAndMinutes,
                        fullDate: event.timestamp.dayAndMonthAndYear,
                        isFromCurrentUser: false,
                        isReply: false,
                        reactions: [],
                        content: [:],
                        eventSubType: "",
                        eventDate: event.timestamp
                    )
                )
            }

            let value = RoomEvent(
                eventId: event.eventId,
                roomId: event.roomId,
                sender: event.sender,
                sentState: .sent,
                eventType: makeEventType(event: event),
                shortDate: event.timestamp.hoursAndMinutes,
                fullDate: event.timestamp.dayAndMonthAndYear,
                isFromCurrentUser: event.sender == matrixUseCase.getUserId(),
                isReply: event.isReply(),
                reactions: reactions,
                content: event.content,
                eventSubType: event.type,
                eventDate: event.timestamp,
                videoThumbnail: videoThumbnail(event: event)
            )
            events.append(value)
        }
        return events
    }

    func makeEventType(event: MXEvent) -> MessageType {
        let messageType = event.content[.messageType] as? String

        var type: MessageType = .none
        let homeServer = Configuration.shared.matrixURL
        switch messageType {
            case kMXMessageTypeText:
                if event.isReply() {
                    let reply = MXReplyEventParser().parse(event)
                    type = .text(reply?.bodyParts.replyText ?? text(event: event))
                } else if event.isEdit() {
                    type = .none
                } else {
                    type = .text(text(event: event))
                }
            case kMXMessageTypeVideo:
                if ChatRoomTogglesFacade().isVideoMessageAvailable {
                    let link = event.content[.url] as? String ?? ""
                    let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
                    type = .video(url)
                } else {
                    type = .none
                }
            case kMXMessageTypeAudio:
                let link = event.content[.url] as? String ?? ""
                let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
                type = .audio(url)
            case kMXMessageTypeImage:
                let link = event.content[.url] as? String ?? ""
                let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
                type = .image(url)
            case kMXMessageTypeLocation:
                let latitude = event.content[.latitude] as? String ?? ""
                let longitude = event.content[.longitude] as? String ?? ""
                type = .location((lat: Double(latitude) ?? 0, long: Double(longitude) ?? 0))
            case kMXMessageTypeFile:
                let link = event.content[.url] as? String ?? ""
                let fileName = event.content[.body] as? String ?? ""
                let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
                type = .file(fileName, url)
            case MXEventCustomEvent.contactInfo.identifier:
                let link = event.content[.avatar] as? String ?? ""
                let name = event.content[.name] as? String ?? ""
                let phone = event.content[.phone] as? String ?? ""
                let url = MXURL(mxContentURI: link)?.contentURL(on: homeServer)
                type = .contact(name: name, phone: phone, url: url)
            case MXEventCustomEvent.cryptoSend.identifier:
                type = .sendCrypto
            default:
                type = makeSystemEventType(event: event)
        }
        return type
    }

    func makeSystemEventType(event: MXEvent) -> MessageType {
        if event.type == EventTypeKeys.groupCallWidget {
            return .groupCall(eventId: event.eventId, text: makeTextForGroupCall(event: event))
        }

        if // event.eventType == .callAnswer ||
            event.eventType == .callHangup ||
            event.eventType == .callReject {
            return .call
        }

        if event.type == EventTypeKeys.roomEncryption {
            return .encryption(
                R.string.localizable.chatRoomViewEncryptedMessagesNotify()
            )
        }

        let displayName: String = (event.content["displayname"] as? String) ?? ""
        if event.type == EventTypeKeys.roomAvatar {
            return .avatarChange( " \(displayName) " +
                R.string.localizable.chatRoomViewSelfAvatarChangeNotify()
            )
        }

        guard event.type == EventTypeKeys.roomMember,
           let membership = event.content["membership"] as? String else {
               return .none
        }

        if membership == EventTypeKeys.roomLeave {
            return .leaveRoom("\(displayName) " + R.string.localizable.chatRoomViewLeftTheRoomNotify())
        }

        if membership == EventTypeKeys.roomInvite {
            return .inviteToRoom("\(displayName) " + R.string.localizable.chatRoomViewInvitedNotify())
        }
        return .none
    }

    func videoThumbnail(event: MXEvent) -> URL? {
        let homeServer = Configuration.shared.matrixURL
        let data = event.content[.info] as? [String: Any]
        let thumbnailLink = data?[.thumbnailUrl] as? String ?? ""
        let url = MXURL(mxContentURI: thumbnailLink)?.contentURL(on: homeServer)
        return url
    }

    func audioDuration(event: MXEvent) -> String {
        var data = event.content["info"] as? [String: Any]
        let msc = event.content["org.matrix.msc1767.audio"] as? [String: Any]
        if msc != nil {
            data = msc
        }

        guard data != nil else { return "" }
        let duration = data?["duration"] as? Int ?? 0
        let time = intToDate(duration)
        return time
    }

    func text(event: MXEvent) -> String {
        if !event.isEdit() {
            return (event.content[.body] as? String).map {
                $0.trimmingCharacters(in: .controlCharacters)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } ?? "Error: expected string body"
        } else {
            let newContent = event.content[.newContent] as? NSDictionary
            return (newContent?[MXEventEventKey.body] as? String).map {
                $0.trimmingCharacters(in: .controlCharacters)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } ?? "Error: expected string body"
        }
    }

    func makeTextForGroupCall(event: MXEvent) -> String {

        guard (event.content["type"] as? String) != nil,
              (event.content["url"] as? String) != nil
        else {
            return R.string.localizable.groupCallInactiveConference()
        }

        return R.string.localizable.groupCallActiveConference()
    }
}
