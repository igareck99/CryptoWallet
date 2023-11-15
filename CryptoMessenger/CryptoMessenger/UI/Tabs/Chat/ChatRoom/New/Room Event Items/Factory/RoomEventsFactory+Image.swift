import SwiftUI

extension RoomEventsFactory {
    static func makeImageItem(
        event: RoomEvent,
        url: URL?,
        delegate: ChatEventsDelegate,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void
    ) -> any ViewGeneratable {
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            dateColor: .white,
            backColor: .osloGrayApprox,
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState, messageType: event.eventType)
        )

        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let items: [ReactionNewEvent] = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        var viewModel: any ViewGeneratable
        if !items.isEmpty {
            viewModel = ReactionsNewViewModel(width: calculateEventWidth(StaticRoomEventsSizes.image.size, items.count),
                                                  views: items,
                                                  backgroundColor: reactionColor)
        } else {
            viewModel = ZeroViewModel()
        }

        let loadInfo = LoadInfo(
            url: .mock,
            textColor: .white,
            backColor: .osloGrayApprox
        )
        let transactionItem = ImageEvent(
            imageUrl: url,
            size: event.dataSize,
            eventData: eventData,
            loadData: loadInfo
        ) { resultUrl in
            debugPrint("onTap ImageEvent")
            delegate.onImageTap(imageUrl: resultUrl)
        }

        let bubbleContainer = BubbleContainer(
            offset: .zero,
            fillColor: .diamond,
            cornerRadius: .equal,
            content: transactionItem
        )

        if event.isFromCurrentUser {
            return EventContainer(
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer,
                bottomContent: viewModel, onLongPress: {
                   onLongPressTap(event)
                }
            )
        }

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            bottomContent: viewModel, onLongPress: {
                onLongPressTap(event)
            }
        )
    }
}
