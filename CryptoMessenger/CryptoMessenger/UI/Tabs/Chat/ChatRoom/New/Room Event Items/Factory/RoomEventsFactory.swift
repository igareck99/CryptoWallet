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
            case let .image(url):
                guard let url = url else { return }
                data.append(makeImageMessage($0, url))
            default:
                break
            }
        }
        return data
    }
    
    static func makeImageMessage(_ event: RoomEvent, _ url: URL) -> any ViewGeneratable {
        let imageItem = ImageItem(date: event.shortDate,
                                  url: url,
                                  reactionItems: [],
                                  readStatus: .read) {
        }
        return imageItem
    }
    
    static func makeCurrentUserText(_ event: RoomEvent, _ text: String) -> any ViewGeneratable {
        let reactionColor: Color = event.isFromCurrentUser ? .brilliantAzure: .aliceBlue
        let items: [ReactionNewEvent] = [.init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "😎",
                                               color: reactionColor,
                                               emojiCount: 10, onTap: { _ in
            
        }),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "😚",
                                               color: reactionColor,
                                               emojiCount: 2, onTap: { _ in
            
        }),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "🎃",
                                               color: reactionColor,
                                               emojiCount: 134, onTap: { _ in
            
        }),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "😺",
                                               color: reactionColor,  onTap: { _ in
            
        }),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "👵",
                                               color: reactionColor, onTap: { _ in
            
        })]
        let viewModel = ReactionsNewViewModel(width: calculateWidth(text, items.count),
                                              views: items)
        let textEvent = TextEvent(
            userId: event.sender, isFromCurrentUser: event.isFromCurrentUser, avatarUrl: event.senderAvatar,
            text: text, width: calculateWidth(text, items.count),
            eventData: EventData(
                date: event.shortDate,
                readData: ReadData(readImageName: R.image.chat.readCheckWhite.name)
            ),
            reactionsGrid: viewModel
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
                                               color: reactionColor,
                                               emojiCount: 10, onTap: { _ in
        }),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "😚",
                                               color: reactionColor,
                                               emojiCount: 2, onTap: { _ in
        }),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "🎃",
                                               color: reactionColor,
                                               emojiCount: 134, onTap: { _ in
        }),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "😺",
                                               color: reactionColor,  onTap: { _ in
        }),
                                         .init(eventId: "",
                                               sender: "",
                                               timestamp: Date(),
                                               emoji: "👵",
                                               color: reactionColor, onTap: { _ in
        })]
        let viewModel = ReactionsNewViewModel(width: calculateWidth(text, items.count),
                                              views: items)
        let textEvent = TextEvent(
            userId: event.sender, isFromCurrentUser: event.isFromCurrentUser, avatarUrl: event.senderAvatar,
            text: text, width: calculateWidth(text, items.count),
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
    // TODO: - Добавить Остаток от деления, а не саму длину текста
    var textWidth = CGFloat(0)
    if reactionsWidth > text.width(font: .systemFont(ofSize: 17)).truncatingRemainder(dividingBy: 228) {
        textWidth = reactionsWidth + 8 + dateWidth
    } else {
        textWidth = text.width(font: .systemFont(ofSize: 17)) + 8 + dateWidth
    }
    let maxWidth = UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.3
    return textWidth < maxWidth ? textWidth : maxWidth
}
