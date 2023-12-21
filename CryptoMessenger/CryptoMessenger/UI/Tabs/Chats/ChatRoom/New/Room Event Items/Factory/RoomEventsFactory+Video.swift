import Foundation

extension RoomEventsFactory {
    static func makeVideoItem(
        event: RoomEvent,
        oldEvents: [RoomEvent],
        oldViews: [any ViewGeneratable],
        url: URL?,
        delegate: ChatEventsDelegate,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onSwipeReply: @escaping (RoomEvent) -> Void
    ) -> (any ViewGeneratable)? {
        if event.sentState == .sent {
            let oldEvent = oldEvents.first(where: { $0.eventId == event.eventId })
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
            fillColor: event.isFromCurrentUser ? .water : .white,
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
                onLongPress: {
                    onLongPressTap(event)
                }
            )
        }

        return EventContainer(
            id: event.id,
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            onLongPress: {
                onLongPressTap(event)
            }
        )
    }
}
