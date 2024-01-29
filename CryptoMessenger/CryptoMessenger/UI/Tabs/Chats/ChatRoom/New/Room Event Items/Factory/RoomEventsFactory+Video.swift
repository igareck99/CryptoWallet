import SwiftUI

extension RoomEventsFactory {
    static func makeVideoItem(
        event: RoomEvent,
        nextMessagePadding: CGFloat,
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
            backColor: .chineseBlack04,
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
        let videoEventItem = VideoEvent(
            videoUrl: url ?? .mock,
            thumbnailurl: event.videoThumbnail,
            size: event.videoSize,
            placeholder: ShimmerModel(),
            eventData: eventData,
            loadData: loadInfo
        ) { videoUrl in
            delegate.onVideoTap(url: videoUrl)
        }

        let bubbleContainer = BubbleContainer(
            offset: 0,
            horizontalOffset: 0.0, isFromCurrentUser: event.isFromCurrentUser,
            fillColor: event.isFromCurrentUser ? .bubbles : .white,
            cornerRadius: .equal,
            content: videoEventItem,
            onSwipe: { onSwipeReply(event) },
            swipeEdge: event.isFromCurrentUser ? .trailing : .leading
        )

        if event.isFromCurrentUser {
            return EventContainer(
                id: event.id,
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer,
                bottomContent: viewModel,
                reactionsSpacing: 6.0,
                nextMessagePadding: nextMessagePadding, onLongPress: {
                    onLongPressTap(event)
                }, onTap: {}
            )
        }

        return EventContainer(
            id: event.id,
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            bottomContent: viewModel,
            reactionsSpacing: 6.0,
            nextMessagePadding: nextMessagePadding, onLongPress: {
                onLongPressTap(event)
            }, onTap: {}
        )
    }
}
