import Foundation

extension RoomEventsFactory {
    static func makeVideoItem(
        event: RoomEvent,
        url: URL?,
        delegate: ChatEventsDelegate,
        onLongPressTap: @escaping (RoomEvent) -> Void
    ) -> any ViewGeneratable {
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
            offset: 0, fillColor: .diamond,
            cornerRadius: .equal,
            content: videoEventItem
        )

        if event.isFromCurrentUser {
            return EventContainer(
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer,
                onLongPress: {
                    onLongPressTap(event)
                }
            )
        }

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            onLongPress: {
                onLongPressTap(event)
            }
        )
    }
}
