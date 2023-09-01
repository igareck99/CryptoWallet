import Foundation
import SwiftUI

// MARK: - RoomEventsFactoryProtocol

protocol RoomEventsFactoryProtocol {
    static func makeEventView(events: [RoomEvent]) -> [any ViewGeneratable]
}

enum RoomEventsFactory: RoomEventsFactoryProtocol {

    static func makeEventView(events: [RoomEvent]) -> [any ViewGeneratable] {
        let data: [any ViewGeneratable] = events.compactMap {
            switch $0.eventType {
            case let .text(string):
                if $0.isFromCurrentUser {
                    return makeCurrentUserText($0, string)
                } else {
                    return makeAnotherUserText($0, string)
                }
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
            default:
                    debugPrint("$0.eventType: \($0.eventType)")
                return nil
            }
        }
        return data
    }

    static func makeCurrentUserText(_ event: RoomEvent, _ text: String) -> any ViewGeneratable {
        let reactionColor: Color = event.isFromCurrentUser ? .brilliantAzure : .aliceBlue
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
        let reactionItems = [ReactionTextsItem(texts: [ReactionTextItem(text: "😎:1015")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "😚:182")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "🤖:34")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "🎃")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "😺")], backgroundColor: reactionColor),
                             ReactionTextsItem(texts: [ReactionTextItem(text: "👵")], backgroundColor: reactionColor)]
        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
        let textEvent = TextEvent(
            userId: event.sender,
            isFromCurrentUser: event.isFromCurrentUser,
            avatarUrl: event.senderAvatar,
            text: text,
            width: calculateWidth(text, reactionItems.count),
            eventData: EventData(
                date: event.shortDate,
                readData: ZeroViewModel()
            ),
            reactionsGrid: ZeroViewModel()//reactionsGrid
        )
        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .left,
            content: textEvent
        )

        let userAvatar = UserAvatar(
//            avatarUrl: event.senderAvatar,
            placeholder: AvatarLetter(letter: "FP")
        )

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
