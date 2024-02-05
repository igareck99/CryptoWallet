import Foundation
import SwiftUI

// MARK: - RoomEventsFactoryProtocol

protocol RoomEventsFactoryProtocol {

    static func makeChatOutputEvent(_ id: UUID,
                                    _ eventId: String,
                                    _ type: MessageType,
                                    _ roomId: String,
                                    _ sender: String,
                                    _ isFromCurrentUser: Bool,
                                    _ isReply: Bool) -> RoomEvent
    static func makeOneEventView(
        value: RoomEvent,
        events: [RoomEvent],
        currentEvents: [RoomEvent],
        oldViews: [any ViewGeneratable],
        delegate: ChatEventsDelegate,
        onLongPressMessage: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void,
        onTapNotSendedMessage: @escaping (RoomEvent) -> Void,
        onSwipeReply: @escaping (RoomEvent) -> Void,
        onTap: @escaping (RoomEvent) -> Void
    ) -> (any ViewGeneratable)?
}

enum RoomEventsFactory: RoomEventsFactoryProtocol {

    static func prepareReaction(
        _ event: RoomEvent,
        onReactionTap: @escaping (ReactionNewEvent) -> Void
    ) -> [ReactionNewEvent] {
        var data: [ReactionNewEvent] = []
        var emojiList: [String] = []
        for reaction in event.reactions {
            if !emojiList.contains(reaction.emoji) {
                emojiList.append(reaction.emoji)
                let background = computeReactionColor(reaction, event, [])
                let textColor = computeTextColor(reaction, event, [])
                data.append(ReactionNewEvent(eventId: reaction.id,
                                             sender: "",
                                             relatedEvent: event.eventId,
                                             timestamp: Date(),
                                             emoji: reaction.emoji,
                                             color: background,
                                             emojiString: "", textColor: textColor,
                                             sendersIds: [reaction.sender],
                                             isFromCurrentUser: reaction.isFromCurrentUser,
                                             onTap: { reaction in
                    onReactionTap(reaction)
                }))
            } else {
                if let index = data.firstIndex(where: { $0.emoji == reaction.emoji }) {
                    let emojiCount = data[index].emojiCount + 1
                    let isFromCurrentUser = data[index].isFromCurrentUser || reaction.isFromCurrentUser
                    var senders = data[index].sendersIds
                    senders.append(reaction.sender)
                    let background: Color = computeReactionColor(reaction, event, senders)
                    let textColor = computeTextColor(reaction, event, senders)
                    data[index] = ReactionNewEvent(eventId: reaction.id,
                                                   sender: "",
                                                   relatedEvent: event.eventId,
                                                   timestamp: Date(),
                                                   emoji: reaction.emoji,
                                                   color: background,
                                                   emojiString: emojiCount.value,
                                                   textColor: textColor,
                                                   emojiCount: emojiCount,
                                                   sendersIds: senders,
                                                   isFromCurrentUser: isFromCurrentUser,
                                                   onTap: { reaction in
                        onReactionTap(reaction)
                    })
                }
            }
        }
        data = data.sorted(by: { $0.emojiCount > $1.emojiCount })
        return data
    }
    
    static func computeReactionColor(_ reaction: Reaction,
                                     _ event: RoomEvent,
                                     _ senders: [String]) -> Color {
        var background: Color
        if senders.contains(MatrixUseCase.shared.getUserId()) {
            background = .brilliantAzure
        } else if reaction.isFromCurrentUser {
            background = .brilliantAzure
        } else {
            if event.isFromCurrentUser {
                background = .diamond
            } else {
                background = .aliceBlue
            }
        }
        return background
    }
    
    static func computeTextColor(_ reaction: Reaction,
                                 _ event: RoomEvent,
                                 _ senders: [String]) -> Color {
        var textColor: Color
        if senders.contains(MatrixUseCase.shared.getUserId()) {
            textColor = .white
        } else if reaction.isFromCurrentUser {
            textColor = .white
        } else {
            textColor = .brilliantAzure
        }
        return textColor
    }
    
    static func nextMessagePadding(_ event: RoomEvent,
                                   _ events: [RoomEvent]) -> CGFloat {
        guard let nextEvent = events.next(item: event) else { return 4.0 }
        if event.isFromCurrentUser && nextEvent.isFromCurrentUser {
            return 4.0
        } else if !event.isFromCurrentUser && !nextEvent.isFromCurrentUser {
            return 4.0
        } else {
            return 8.0
        }
    }
    
    static func makeOneEventView(
        value: RoomEvent,
        events: [RoomEvent],
        currentEvents: [RoomEvent] = [],
        oldViews: [any ViewGeneratable],
        delegate: ChatEventsDelegate,
        onLongPressMessage: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void,
        onTapNotSendedMessage: @escaping (RoomEvent) -> Void,
        onSwipeReply: @escaping (RoomEvent) -> Void,
        onTap: @escaping (RoomEvent) -> Void
    ) -> (any ViewGeneratable)? {
        let nextMessagePadding = nextMessagePadding(value, currentEvents)
        switch value.eventType {
        case let .text(string):
            return makeTextView(value, nextMessagePadding,
                                events, currentEvents, oldViews, string, onLongPressTap: { eventId in
                onLongPressMessage(eventId)
            }, onReactionTap: { reaction in
                onReactionTap(reaction)
            }, onSwipeReply: { value in
                onSwipeReply(value)
            }, onTap: { value in
                onTap(value)
            })
        case .call:
            return makeCallItem(
                event: value, nextMessagePadding: nextMessagePadding,
                delegate: delegate
            ) { event in
                onLongPressMessage(event)
            }
        case let .contact(name, phone, url):
            return makeContactItem(
                event: value, nextMessagePadding: nextMessagePadding,
                oldEvents: events,
                oldViews: oldViews,
                name: name,
                phone: phone,
                url: url,
                delegate: delegate,
                onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                }, onSwipeReply: { value in
                    onSwipeReply(value)
                })
        case let .file(name, url):
            return makeDocumentItem(
                event: value, nextMessagePadding: nextMessagePadding,
                oldEvents: events,
                oldViews: oldViews,
                name: name,
                url: url,
                delegate: delegate,
                onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                }, onSwipeReply: { value in
                    onSwipeReply(value)
                })
        case let .location((lat, lon)):
            return makeMapItem(
                event: value, nextMessagePadding: nextMessagePadding,
                oldEvents: events,
                oldViews: oldViews,
                lat: lat,
                lon: lon,
                delegate: delegate,
                onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                }, onNotSentTap: { event in
                    onTapNotSendedMessage(event)
                }, onSwipeReply: { value in
                    onSwipeReply(value)
                })
        case let .image(url):
            return makeImageItem(
                event: value, nextMessagePadding: nextMessagePadding, oldEvents: events, oldViews: oldViews,
                url: url,
                delegate: delegate,
                onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                }, onSwipeReply: { value in
                    onSwipeReply(value)
                })
        case let .audio(url):
            return makeAudioItem(
                event: value, nextMessagePadding: nextMessagePadding,
                oldEvents: events,
                oldViews: oldViews,
                url: url,
                onLongPressTap: { event in onLongPressMessage(event) },
                onReactionTap: { reaction in onReactionTap(reaction) },
                onSwipeReply: { value in onSwipeReply(value) }
            )
        case let .video(url):
            return makeVideoItem(
                event: value, nextMessagePadding: nextMessagePadding,
                oldEvents: events,
                oldViews: oldViews,
                url: url,
                delegate: delegate,
                onLongPressTap: { event in onLongPressMessage(event) },
                onReactionTap: { reaction in onReactionTap(reaction) },
                onSwipeReply: { value in onSwipeReply(value) }
            )
            case let .groupCall(eventId, text):
            return makeSystemEventItem(text: text, nextMessagePadding: nextMessagePadding) {
                    debugPrint("onTap groupCall SystemEventItem")
                    delegate.onGroupCallTap(eventId: eventId)
                }
            case let .encryption(text):
            return makeSystemEventItem(text: text, nextMessagePadding: nextMessagePadding) {
                    debugPrint("onTap encryption SystemEventItem")
                }
            case let .avatarChange(text):
            return makeSystemEventItem(text: text, nextMessagePadding: nextMessagePadding) {
                    debugPrint("onTap avatarChange SystemEventItem")
                }
            case let .leaveRoom(text):
            return makeSystemEventItem(text: text, nextMessagePadding: nextMessagePadding) {
                    debugPrint("onTap leaveRoom SystemEventItem")
                }
            case let .inviteToRoom(text):
            return makeSystemEventItem(text: text, nextMessagePadding: nextMessagePadding) {
                    debugPrint("onTap inviteToRoom SystemEventItem")
                }
            case .sendCrypto:
                return makeTransactionItem(
                    delegate: delegate,
                    event: value, nextMessagePadding: nextMessagePadding,
                    onLongPressTap: onLongPressMessage,
                    onSwipeReply: onSwipeReply,
                    onReactionTap: onReactionTap
                )
            default:
                // MARK: - Оставил в целях отладки
                /*
                 debugPrint("$0.eventType: \(value.eventSubType)")
                 debugPrint("$0.eventType: \(value.eventType)")
                 debugPrint("$0.eventType: \(value.content)")
                */
                return nil
        }
    }

    static func makeTextView(_ event: RoomEvent,
                             _ nextMessagePadding: CGFloat,
                             _ oldEvents: [RoomEvent],
                             _ currentEvents: [RoomEvent],
                             _ oldViews: [any ViewGeneratable],
                             _ text: String,
                             onLongPressTap: @escaping (RoomEvent) -> Void,
                             onReactionTap: @escaping (ReactionNewEvent) -> Void,
                             onSwipeReply: @escaping (RoomEvent) -> Void,
                             onTap: @escaping (RoomEvent) -> Void) -> (any ViewGeneratable)? {
        var event = event
        var eventReply = ""
        let oldEvent = oldEvents.first(where: { $0.eventId == event.eventId })
        if event.sentState == .sent {
            if oldEvent == event && !event.isReply {
                guard let view = oldViews.first(where: { $0.id == event.id }) else { return nil }
                return view
            } else if oldEvent == event {
                let eventReplyEvent = currentEvents.first(where: { $0.eventId == event.rootEventId })
                if eventReplyEvent == nil {
                    event = RoomEvent(id: event.id,
                                      eventId: event.eventId,
                                      roomId: event.roomId,
                                      sender: event.sender,
                                      sentState: event.sentState,
                                      eventType: event.eventType,
                                      shortDate: event.shortDate,
                                      fullDate: event.fullDate,
                                      isFromCurrentUser: event.isFromCurrentUser,
                                      isReply: false,
                                      reactions: event.reactions,
                                      content: event.content,
                                      eventSubType: event.eventSubType,
                                      eventDate: event.eventDate,
                                      senderAvatar: event.senderAvatar,
                                      videoThumbnail: event.videoThumbnail)
                } else {
                    eventReply = makeReplyDescription(eventReplyEvent)
                }
            }
        }
        if event.isReply && eventReply.isEmpty {
            let eventReplyEvent = currentEvents.first(where: { $0.eventId == event.rootEventId })
            if eventReplyEvent == nil || eventReplyEvent?.eventType == MessageType.none {
                event = RoomEvent(id: event.id,
                                  eventId: event.eventId,
                                  roomId: event.roomId,
                                  sender: event.sender,
                                  sentState: event.sentState,
                                  eventType: event.eventType,
                                  shortDate: event.shortDate,
                                  fullDate: event.fullDate,
                                  isFromCurrentUser: event.isFromCurrentUser,
                                  isReply: false,
                                  reactions: event.reactions,
                                  content: event.content,
                                  eventSubType: event.eventSubType,
                                  eventDate: event.eventDate,
                                  senderAvatar: event.senderAvatar,
                                  videoThumbnail: event.videoThumbnail)
            } else {
                eventReply = makeReplyDescription(eventReplyEvent)
            }
        }
        let reactionColor: Color = event.isFromCurrentUser ? .diamond : .aliceBlue
        let reactions = prepareReaction(
            event,
            onReactionTap: { reaction in
                onReactionTap(reaction)
            }
        )
        var viewModel: ReactionsNewViewModel
        if oldEvent?.reactions == event.reactions {
            viewModel = ReactionsNewViewModel(
                id: event.id,
                width: calculateWidth("", reactions.count),
                views: reactions,
                backgroundColor: reactionColor
            )
        } else {
            viewModel = ReactionsNewViewModel(
                width: calculateWidth("", reactions.count),
                views: reactions,
                backgroundColor: reactionColor
            )
        }
        let textEvent = TextEvent(
            id: event.id, userId: event.sender, isFromCurrentUser: event.isFromCurrentUser, avatarUrl: event.senderAvatar,
            text: text, isReply: event.isReply,
            replyDescription: eventReply,
            width: calculateWidth(text, reactions.count),
            isEmptyReactions: reactions.isEmpty,
            eventData: EventData(
                date: event.shortDate,
                isFromCurrentUser: event.isFromCurrentUser,
                readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState, messageType: event.eventType)
            ),
            reactionsGrid: viewModel
        )
        var contatiner: BubbleContainer
        if event.isFromCurrentUser {
            contatiner = BubbleContainer(
                offset: 8.0,
                horizontalOffset: 12.0,
                isFromCurrentUser: event.isFromCurrentUser, fillColor: .bubbles,
                cornerRadius: .right,
                content: textEvent, onSwipe: {
                    onSwipeReply(event)
                }, swipeEdge: event.isFromCurrentUser ? .trailing : .leading
            )
            return EventContainer(
                id: event.id,
                leadingContent: PaddingModel(),
                centralContent: contatiner,
                reactionsSpacing: 24,
                nextMessagePadding: nextMessagePadding, onLongPress: {
                    onLongPressTap(event)
                }, onTap: {
                    onTap(event)
                }
            )
        } else {
            contatiner = BubbleContainer(
                offset: 8.0,
                horizontalOffset: 12.0,
                isFromCurrentUser: event.isFromCurrentUser, fillColor: .white,
                cornerRadius: .left,
                content: textEvent, onSwipe: {
                    onSwipeReply(event)
                }, swipeEdge: event.isFromCurrentUser ? .trailing : .leading
            )
            return EventContainer(
                id: event.id,
                centralContent: contatiner,
                trailingContent: PaddingModel(),
                reactionsSpacing: 24,
                nextMessagePadding: nextMessagePadding, onLongPress: {
                    onLongPressTap(event)
                }, onTap: {
                    onTap(event)
                }
            )
        }
    }
    
    static func makeReplyDescription(_ event: RoomEvent?) -> String {
        guard let event = event else { return "" }
        switch event.eventType {
        case .text(let string):
            return string
        case .image(_):
            return "send to image"
        case .video(_):
            return "send to video"
        case .file(_, _):
            return "send to video"
        case .audio(_):
            return "send to audio"
        case .location(_):
            return "send to location"
        case .contact(_, _, _):
            return "send to contact"
        default:
            return ""
        }
    }

    static func readData(
        isFromCurrentUser: Bool,
        eventSendType: RoomSentState,
        messageType: MessageType
    ) -> any ViewGeneratable {
        var checkReadImage: Image
        switch messageType {
        case .video(_), .image(_), .location((_, _)):
            checkReadImage = (eventSendType == .sent || eventSendType == .sentLocaly)
            ? R.image.chat.whiteChecked.image : R.image.chat.whiteSending.image
        default:
            checkReadImage = (eventSendType == .sent || eventSendType == .sentLocaly)
            ? R.image.chat.sendedCheck.image : R.image.chat.sendingCheck.image
        }
        if isFromCurrentUser {
            return ReadData(readImageName: checkReadImage)
        }
        return ZeroViewModel()
    }
    
    static func makeChatOutputEvent(_ id: UUID,
                                    _ eventId: String,
                                    _ type: MessageType,
                                    _ roomId: String,
                                    _ sender: String,
                                    _ isFromCurrentUser: Bool,
                                    _ isReply: Bool) -> RoomEvent {
        let date = Date().timeIntervalSince1970
        let event = RoomEvent(
            id: id,
            eventId: eventId,
            roomId: roomId,
            sender: sender,
            sentState: .sending,
            eventType: type,
            shortDate:  Date().hoursAndMinutes,
            fullDate: "",
            isFromCurrentUser: isFromCurrentUser,
            isReply: isReply,
            reactions: [],
            content: [:],
            eventSubType: "",
            eventDate: Date()
        )
        return event
    }
}

func calculateWidth(_ text: String, _ reactions: Int = 0) -> CGFloat {

    let dateWidth = CGFloat(64)
    let reactionsWidth = CGFloat(38 * reactions)
    var textWidth = CGFloat(0)
    if reactionsWidth > text.width(font: .systemFont(ofSize: 17)).truncatingRemainder(dividingBy: 289) {
        textWidth = reactionsWidth + 8 + dateWidth
    } else {
        textWidth = text.width(font: .systemFont(ofSize: 17)) + 12 + dateWidth
    }
    let maxWidth = CGFloat(289)
    return textWidth < maxWidth ? textWidth : maxWidth
}
