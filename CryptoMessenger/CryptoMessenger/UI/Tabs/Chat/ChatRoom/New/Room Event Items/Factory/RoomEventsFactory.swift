import Foundation
import SwiftUI

// MARK: - RoomEventsFactoryProtocol

protocol RoomEventsFactoryProtocol {
    
    static func makeEventView(events: [RoomEvent]) -> [any ViewGeneratable]

    static func makeSystemEventItem(
        date: String,
        text: String,
        type: SystemEventType,
        onTap: @escaping () -> Void
    ) -> SystemEventItem

    static func makeReplyItem(
        date: String,
        repliedItemId: String,
        text: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void,
        onReplyTap: @escaping () -> Void
    ) -> ReplyItem

    static func makeLocationItem(
        date: String,
        coordinate: Coordinate,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> LocationItem

    static func makeAudioItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> AudioItem

    static func makeVideoItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> VideoItem

    static func makeImageItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> ImageItem
}

enum RoomEventsFactory: RoomEventsFactoryProtocol {

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

    static func makeLocationItem(
        date: String,
        coordinate: Coordinate,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> LocationItem {
        LocationItem(
            date: date,
            coordinate: coordinate,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeAudioItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> AudioItem {
        AudioItem(
            date: date,
            url: url,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeVideoItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> VideoItem {
        VideoItem(
            date: date,
            url: url,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeImageItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> ImageItem {
        ImageItem(
            date: date,
            url: url,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeEventView(events: [RoomEvent]) -> [any ViewGeneratable] {
        var data: [any ViewGeneratable] = []
        events.map {
            switch $0.eventType {
            case let .text(string):
                if $0.isFromCurrentUser {
                    data.append(makeCurrentUserText($0, string))
                } else {
                    data.append(makeAnotherUserText($0, string))
                }
            default:
                break
            }
        }
        return data
    }
    
    static func makeCurrentUserText(_ event: RoomEvent, _ text: String) -> any ViewGeneratable {
        let reactionColor: Color = event.isFromCurrentUser ? .brilliantAzure: .aliceBlue
        let reactionItems = [ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: reactionColor)]
        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
        let textEvent = TextEvent(
            userId: event.sender, isFromCurrentUser: event.isFromCurrentUser, avatarUrl: event.senderAvatar,
            text: text, width: calculateWidth(text),
            eventData: EventData(
                date: event.shortDate,
                readData: ReadData(readImageName: R.image.chat.readCheckWhite.name)
            ),
            reactionsGrid: reactionsGrid
        )
        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .right,
            content: textEvent
        )

        return EventContainer(
            leadingContent: PaddingModel(),
            centralContent: bubbleContainer
        )
    }
    
    static func makeAnotherUserText(_ event: RoomEvent, _ text: String) -> any ViewGeneratable {
        let reactionColor: Color = event.isFromCurrentUser ? .brilliantAzure: .aliceBlue
        let items: [ReactionNewEvent] = [.init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "😎",
                                               color: reactionColor),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "😚",
                                               color: reactionColor),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "🎃",
                                               color: reactionColor),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "😺",
                                               color: reactionColor),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "👵",
                                               color: reactionColor)]
        let viewModel = ReactionsNewViewModel(width: 218,
                                              views: items)
        let reactionItems = [ReactionTextsItem(texts: [ReactionTextItem(text: "😎:1015")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "😚:182")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "🤖:34")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "🎃")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "😺")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "👵")], backgroundColor: reactionColor)]
        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
        let textEvent = TextEvent(
            userId: event.sender, isFromCurrentUser: event.isFromCurrentUser, avatarUrl: event.senderAvatar,
            text: text, width: calculateWidth(text, reactionItems.count),
            eventData: EventData(
                date: event.shortDate,
                readData: ZeroViewModel()
            ),
            reactionsGrid: viewModel
        )
        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .left,
            content: textEvent
        )
        let userAvatar = UserAvatar(avatarUrl: event.senderAvatar,
                                    placeholder: AvatarLetter(letter: "FP"))
        return EventContainer(
            leadingContent: userAvatar,
            centralContent: bubbleContainer,
            trailingContent: PaddingModel()
        )
    }
}


func calculateWidth(_ text: String, _ reactions: Int = 0) -> CGFloat {
    let dateWidth = CGFloat(32)
    let reactionsWidth = CGFloat(38 * reactions)
    // TODO: - Добавить реакции
    var textWidth = CGFloat(0)
    if reactionsWidth > text.width(font: .systemFont(ofSize: 17)) {
        textWidth = reactionsWidth + 8 + dateWidth
    } else {
        textWidth = text.width(font: .systemFont(ofSize: 17)) + 8 + dateWidth
    }
    let maxWidth = UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.3
    return textWidth < maxWidth ? textWidth : maxWidth
}
