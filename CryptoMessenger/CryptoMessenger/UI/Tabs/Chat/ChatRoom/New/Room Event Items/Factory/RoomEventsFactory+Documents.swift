import Foundation

extension RoomEventsFactory {
    static func makeDocumentItem(
        event: RoomEvent,
        name: String?,
        url: URL?,
        delegate: ChatEventsDelegate,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void,
        onSwipeReply: @escaping (RoomEvent) -> Void
    ) -> any ViewGeneratable {
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState, messageType: event.eventType)
        )
        let items: [ReactionNewEvent] = []
        let viewModel = ReactionsNewViewModel(
            width: calculateWidth("", items.count),
            views: items,
            backgroundColor: .brilliantAzure
        )
        let docItem = DocumentItem(
            imageName: "paperclip.circle.fill",
            title: name ?? "", // "Экран для Aura.docx",
            size: event.dataSize,
            url: url ?? .mock,
            reactionsGrid: viewModel, // reactionsGrid,
            eventData: eventData
        ) {
            guard let fileUrl = url, let fileName = name else {
                return
            }
            debugPrint("onTap DocumentItem fileUrl: \(fileUrl) fileName: \(fileName)")
            delegate.onDocumentTap(fileUrl: fileUrl, fileName: fileName)
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: docItem, onSwipe: {
                onSwipeReply(event)
            }, swipeEdge: event.isFromCurrentUser ? .trailing : .leading
        )

        if event.isFromCurrentUser {
            return EventContainer(
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer, onLongPress: {
                    onLongPressTap(event)
                }
            )
        }

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(), onLongPress: {
                onLongPressTap(event)
            }
        )
    }
}
