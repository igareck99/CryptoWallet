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
            readData: readData(isFromCurrentUser: event.isFromCurrentUser)
        )
        let loadInfo = LoadInfo(
            url: .mock,
            textColor: .white,
            backColor: .osloGrayApprox
        )
        let videoEventItem = VideoEvent(
            videoUrl: url ?? .mock,
            placeholder: ShimmerModel(),
            eventData: eventData,
            loadData: loadInfo
        ) {
            guard let videoUrl = url else { return }
            delegate.onVideoTap(url: videoUrl)
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .diamond,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
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
