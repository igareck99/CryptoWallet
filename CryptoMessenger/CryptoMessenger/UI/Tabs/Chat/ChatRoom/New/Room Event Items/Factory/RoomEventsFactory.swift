import Foundation
import SwiftUI

// MARK: - RoomEventsFactoryProtocol

protocol RoomEventsFactoryProtocol {
    static func makeEventView(events: [RoomEvent]) -> [any ViewGeneratable]
}

enum RoomEventsFactory: RoomEventsFactoryProtocol {

    static func prepareReaction(_ event: RoomEvent) -> [ReactionNewEvent] {
        let reactionColor: Color = event.isFromCurrentUser ? .diamond : .aliceBlue
        var data: [ReactionNewEvent] = []
        var emojiList: [String] = []
        for reaction in event.reactions {
            if !emojiList.contains(reaction.emoji) {
                emojiList.append(reaction.emoji)
                
                data.append(ReactionNewEvent(eventId: "",
                                             sender: "",
                                             timestamp: Date(),
                                             emoji: reaction.emoji,
                                             color: event.isFromCurrentUser ? .azureRadianceApprox : reactionColor,
                                             emojiString: "",
                                             onTap: { _ in
                }))
            } else {
                if let index = data.firstIndex(where: { $0.emoji == reaction.emoji }) {
                    let emojiCount = data[index].emojiCount + 1
                    data[index] = ReactionNewEvent(eventId: "",
                                                   sender: "",
                                                   timestamp: Date(),
                                                   emoji: reaction.emoji,
                                                   color: event.isFromCurrentUser ? .azureRadianceApprox : reactionColor,
                                                   emojiString: emojiCount.value,
                                                   emojiCount: emojiCount,
                                                   onTap: { _ in
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
    
    static func makeReplyItem(
        date: String,
        repliedItemId: String,
        text: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void,
        onReplyTap: @escaping () -> Void
    ) -> ReplyItem {
        ReplyItem(
            date: date,
            repliedItemId: repliedItemId,
            text: text,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap,
            onReplyTap: onReplyTap
        )
    }
    
    static func makeEventView(events: [RoomEvent]) -> [any ViewGeneratable] {
        
        let data: [any ViewGeneratable] = events.compactMap {
            switch $0.eventType {
            case let .text(string):
                return makeTextView($0, string)
            case .call:
                return makeCallItem(event: $0)
            case let .contact(name, phone, url):
                return makeContactItem(event: $0, name: name, phone: phone, url: url)
            case let .file(name, url):
                return makeDocumentItem(event: $0, name: name, url: url)
            case let .location((lat, lon)):
                return makeMapItem(event: $0, lat: lat, lon: lon)
            case let .image(url):
                return makeImageItem(event: $0, url: url)
            case let .audio(url):
                return makeAudioItem(event: $0, url: url)
            default:
                return nil
            }
        }
        return data
    }
    
    static func makeTextView(_ event: RoomEvent, _ text: String) -> any ViewGeneratable {
        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let reactions = prepareReaction(event)
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
                centralContent: contatiner
            )
        } else {
            contatiner = BubbleContainer(
                fillColor: .water,
                cornerRadius: .left,
                content: textEvent
            )
            return EventContainer(
                centralContent: contatiner,
                trailingContent: PaddingModel()
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
