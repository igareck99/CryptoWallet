import Foundation
import SwiftUI

// MARK: - RoomEventsFactoryProtocol

protocol RoomEventsFactoryProtocol {
    static func makeEventView(events: [RoomEvent],
                              onLongPressMessage: @escaping (RoomEvent) -> Void,
                              onReactionTap: @escaping (ReactionNewEvent) -> Void) -> [any ViewGeneratable]
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

    static func makeSystemEventItem(
        date: String,
        text: String,
        type: SystemEventType,
        onTap: @escaping () -> Void
    ) -> SystemEventItem {
        SystemEventItem(
            date: date,
            text: text,
            type: type,
            onTap: onTap
        )
    }
    
    static func makeEventView(events: [RoomEvent],
                              onLongPressMessage: @escaping (RoomEvent) -> Void,
                              onReactionTap: @escaping (ReactionNewEvent) -> Void) -> [any ViewGeneratable] {
        
        let data: [any ViewGeneratable] = events.compactMap {
            switch $0.eventType {
            case let .text(string):
                return makeTextView($0, string, onLongPressTap: { eventId in
                    onLongPressMessage(eventId)
                }, onReactionTap: { reaction in
                 onReactionTap(reaction)
                })
            case .call:
                return makeCallItem(event: $0, onLongPressTap: { event in
                    onLongPressMessage(event)
                })
            case let .contact(name, phone, url):
                return makeContactItem(event: $0, name: name, phone: phone, url: url, onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                })
            case let .file(name, url):
                return makeDocumentItem(event: $0, name: name, url: url, onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                })
            case let .location((lat, lon)):
                return makeMapItem(event: $0, lat: lat, lon: lon, onLongPressTap: { event in
                    onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    onReactionTap(reaction)
                })
            case let .image(url):
                return makeImageItem(event: $0, url: url, onLongPressTap: { event in
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
            default:
                return nil
            }
        }
        return data
    }
    
    static func makeTextView(_ event: RoomEvent,
                             _ text: String,
                             onLongPressTap: @escaping (RoomEvent) -> Void,
                             onReactionTap: @escaping (ReactionNewEvent) -> Void) -> any ViewGeneratable {
        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let reactions = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        let viewModel = ReactionsNewViewModel(width: calculateWidth("", reactions.count),
                                              views: reactions,
                                              backgroundColor: reactionColor)
        let textEvent = TextEvent(
            userId: event.sender, isFromCurrentUser: event.isFromCurrentUser, avatarUrl: event.senderAvatar,
            text: text, isReply: event.isReply,
            replyDescription:
              event.replyDescription,
            width: calculateWidth(text, reactions.count),
            eventData: EventData(
                date: event.shortDate,
                isFromCurrentUser: event.isFromCurrentUser,
                readData: ReadData(readImageName: R.image.chat.readCheckWhite.name)
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
