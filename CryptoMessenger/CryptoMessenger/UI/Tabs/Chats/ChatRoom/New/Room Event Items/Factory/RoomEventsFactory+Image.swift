import SwiftUI

extension RoomEventsFactory {
    static func makeImageItem(
        event: RoomEvent,
        oldEvents: [RoomEvent],
        oldViews: [any ViewGeneratable],
        url: URL?,
        delegate: ChatEventsDelegate,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void,
        onSwipeReply: @escaping (RoomEvent) -> Void
    ) -> (any ViewGeneratable)? {
        let oldEvent = oldEvents.first(where: { $0.eventId == event.eventId })
        if event.sentState == .sent {
            if oldEvent == event {
                guard let view = oldViews.first(where: { $0.id == event.id }) else { return nil }
                return view
            }
        }
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            dateColor: .white,
            backColor: .osloGrayApprox,
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState, messageType: event.eventType)
        )

        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let reactions: [ReactionNewEvent] = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
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
        let loadInfo = LoadInfo(
            url: .mock,
            textColor: .white,
            backColor: .osloGrayApprox
        )
        let transactionItem = ImageEvent(
            id: event.id,
            imageUrl: url,
            size: event.dataSize,
            sentState: event.sentState,
            eventData: eventData,
            loadData: loadInfo
        ) { image, imageUrl in
            delegate.onImageTap(image: image, imageUrl: imageUrl)
        }

        let bubbleContainer = BubbleContainer(
            offset: .zero,
            isFromCurrentUser: event.isFromCurrentUser,
            fillColor: event.isFromCurrentUser ? .bubbles : .white,
            cornerRadius: .equal,
            content: transactionItem,
            onSwipe: {
                onSwipeReply(event)
            }, swipeEdge: event.isFromCurrentUser ? .trailing : .leading
        )

        if event.isFromCurrentUser {
            return EventContainer(
                id: event.id,
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer,
                bottomContent: viewModel,
                onLongPress: {
                   onLongPressTap(event)
                }
            )
        }

        return EventContainer(
            id: event.id,
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            bottomContent: viewModel,
            onLongPress: {
                onLongPressTap(event)
            }
        )
    }
}
