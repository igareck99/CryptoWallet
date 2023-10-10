import Foundation
import SwiftUI

// MARK: - RoomEventsFactoryProtocol

protocol RoomEventsFactoryProtocol {
    static func makeEventView(
      events: [RoomEvent],
      delegate: ChatEventsDelegate,
      onLongPressMessage: @escaping (RoomEvent) -> Void,
      onReactionTap: @escaping (ReactionNewEvent) -> Void,
      onTapNotSendedMessage: @escaping (RoomEvent) -> Void
    ) -> [any ViewGeneratable]
    static func makeChatOutputEvent(_ eventId: String,
                                    _ type: MessageType,
                                    _ roomId: String,
                                    _ sender: String,
                                    _ isFromCurrentUser: Bool,
                                    _ isReply: Bool) -> RoomEvent
}

enum RoomEventsFactory: RoomEventsFactoryProtocol {

    static func prepareReaction(_ event: RoomEvent,
                                onReactionTap: @escaping (ReactionNewEvent) -> Void) -> [ReactionNewEvent] {
        let reactionColor: Color = event.isFromCurrentUser ? .diamond : .aliceBlue
        var data: [ReactionNewEvent] = []
        var emojiList: [String] = []
        for reaction in event.reactions {
            if !emojiList.contains(reaction.emoji) {
                emojiList.append(reaction.emoji)
                data.append(ReactionNewEvent(eventId: reaction.id,
                                             sender: "",
                                             relatedEvent: event.eventId,
                                             timestamp: Date(),
                                             emoji: reaction.emoji,
                                             color: event.isFromCurrentUser ? .azureRadianceApprox : reactionColor,
                                             emojiString: "",
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
                    data[index] = ReactionNewEvent(eventId: reaction.id,
                                                   sender: "",
                                                   relatedEvent: event.eventId,
                                                   timestamp: Date(),
                                                   emoji: reaction.emoji,
                                                   color: event.isFromCurrentUser ? .azureRadianceApprox : reactionColor,
                                                   emojiString: emojiCount.value,
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
    
    static func makeEventView(
      events: [RoomEvent],
      delegate: ChatEventsDelegate,
      onLongPressMessage: @escaping (RoomEvent) -> Void,
      onReactionTap: @escaping (ReactionNewEvent) -> Void,
      onTapNotSendedMessage: @escaping (RoomEvent) -> Void
    ) -> [any ViewGeneratable] {

        let data: [any ViewGeneratable] = events.compactMap {
            switch $0.eventType {
            case let .text(string):
                return makeTextView($0, events,  string, onLongPressTap: { eventId in
                    onLongPressMessage(eventId)
                }, onReactionTap: { reaction in
                 onReactionTap(reaction)
                })
            case .call:
                return makeCallItem(
                  event: $0, 
                  delegate: delegate
                ) { event in
                    onLongPressMessage(event)
                }
            case let .contact(name, phone, url):
                return makeContactItem(
                  event: $0, 
                  name: name, 
                  phone: phone, 
                  url: url, 
                  delegate: delegate,
                  onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                })
            case let .file(name, url):
                return makeDocumentItem(
                  event: $0, 
                  name: name, 
                  url: url, 
                  delegate: delegate,
                  onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                })
            case let .location((lat, lon)):
                return makeMapItem(
                  event: $0, 
                  lat: lat, 
                  lon: lon, 
                  delegate: delegate,
                  onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                }, onNotSentTap: { event in
                    onTapNotSendedMessage(event)
                })
            case let .image(url):
                return makeImageItem(
                  event: $0, 
                  url: url, 
                  delegate: delegate,
                  onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                })
            case let .audio(url):
                return makeAudioItem(event: $0, url: url, onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                })
            case let .video(url):
                return makeVideoItem(
                    event: $0,
                    url: url,
                    delegate: delegate,
                    onLongPressTap: { event in
                        onLongPressMessage(event)
                    }
                )
            case let .date(dateStr):
                return makeSystemEventItem(text: dateStr) {
                    debugPrint("onTap date SystemEventItem")
                }
            case let .groupCall(eventId, text):
                return makeSystemEventItem(text: text) {
                    debugPrint("onTap groupCall SystemEventItem")
                    delegate.onGroupCallTap(eventId: eventId)
                }
            case let .encryption(text):
                return makeSystemEventItem(text: text) {
                    debugPrint("onTap encryption SystemEventItem")
                }
            case let .avatarChange(text):
                return makeSystemEventItem(text: text) {
                    debugPrint("onTap avatarChange SystemEventItem")
                }
            case let .joinRoom(text):
                return makeSystemEventItem(text: text) {
                    debugPrint("onTap joinRoom SystemEventItem")
                }
            case let .leaveRoom(text):
                return makeSystemEventItem(text: text) {
                    debugPrint("onTap leaveRoom SystemEventItem")
                }
            case let .inviteToRoom(text):
                return makeSystemEventItem(text: text) {
                    debugPrint("onTap inviteToRoom SystemEventItem")
                }
            default:
                debugPrint("$0.eventType: \($0.eventSubType)")
                debugPrint("$0.eventType: \($0.eventType)")
                debugPrint("$0.eventType: \($0.content)")
                return nil
            }
        }
        return data
    }

    static func makeTextView(_ event: RoomEvent,
                             _ events: [RoomEvent],
                             _ text: String,
                             onLongPressTap: @escaping (RoomEvent) -> Void,
                             onReactionTap: @escaping (ReactionNewEvent) -> Void) -> any ViewGeneratable {
        var eventReply = ""
        if event.isReply {
            let eventReplyEvent = events.first(where: { $0.eventId == event.rootEventId })
            eventReply = makeReplyDescription(eventReplyEvent)
        }
        let reactionColor: Color = event.isFromCurrentUser ? .diamond : .aliceBlue
        let reactions = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        let viewModel = ReactionsNewViewModel(width: calculateWidth("", reactions.count),
                                              views: reactions,
                                              backgroundColor: reactionColor)
        let checkReadImage = event.sentState == .sent ? R.image.chat.sendedCheck.image : R.image.chat.sendingCheck.image
        let textEvent = TextEvent(
            userId: event.sender, isFromCurrentUser: event.isFromCurrentUser, avatarUrl: event.senderAvatar,
            text: text, isReply: event.isReply,
            replyDescription: eventReply,
            width: calculateWidth(text, reactions.count),
            eventData: EventData(
                date: event.shortDate,
                isFromCurrentUser: event.isFromCurrentUser,
                readData: ReadData(readImageName: checkReadImage)
            ),
            reactionsGrid: viewModel
        )
        var contatiner: BubbleContainer
        if event.isFromCurrentUser {
            contatiner = BubbleContainer(
                fillColor: .water,
                cornerRadius: .right,
                content: textEvent
            )
            return EventContainer(
                leadingContent: PaddingModel(),
                centralContent: contatiner, onLongPress: {
                    onLongPressTap(event)
                }
            )
        } else {
            contatiner = BubbleContainer(
                fillColor: .water,
                cornerRadius: .left,
                content: textEvent
            )
            return EventContainer(
                centralContent: contatiner,
                trailingContent: PaddingModel(), onLongPress: {
                    onLongPressTap(event)
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

    static func readData(isFromCurrentUser: Bool, eventSendType: RoomSentState,
                         messageType: MessageType) -> any ViewGeneratable {
        var checkReadImage: Image
        switch messageType {
        case .video(_), .image(_):
            // TODO: - Тут добавить одну белую галочку
            checkReadImage = eventSendType == .sent ? R.image.chat.whiteChecked.image : R.image.chat.whiteSending.image
        default:
            checkReadImage = eventSendType == .sent ? R.image.chat.sendedCheck.image : R.image.chat.sendingCheck.image
        }
        if isFromCurrentUser {
            return ReadData(readImageName: checkReadImage)
        }
        return ZeroViewModel()
    }
    
    static func makeChatOutputEvent(_ eventId: String,
                                    _ type: MessageType,
                                    _ roomId: String,
                                    _ sender: String,
                                    _ isFromCurrentUser: Bool,
                                    _ isReply: Bool) -> RoomEvent {
        let date = Date().timeIntervalSince1970
        let event = RoomEvent(eventId: eventId, roomId: roomId,
                              sender: sender, sentState: .sending,
                              eventType: type, shortDate:  Date().hoursAndMinutes,
                              fullDate: "", isFromCurrentUser: isFromCurrentUser,
                              isReply: isReply,
                              reactions: [], content: [:],
                              eventSubType: "")
        return event
    }
}

func calculateWidth(_ text: String, _ reactions: Int = 0) -> CGFloat {

    let dateWidth = CGFloat(32)
    let reactionsWidth = CGFloat(38 * reactions)
    var textWidth = CGFloat(0)
    if reactionsWidth > text.width(font: .systemFont(ofSize: 17)).truncatingRemainder(dividingBy: 228) {
        textWidth = reactionsWidth + 8 + dateWidth
    } else {
        textWidth = text.width(font: .systemFont(ofSize: 17)) + 8 + dateWidth
    }
    let maxWidth = UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.3
    return textWidth < maxWidth ? textWidth : maxWidth
}
