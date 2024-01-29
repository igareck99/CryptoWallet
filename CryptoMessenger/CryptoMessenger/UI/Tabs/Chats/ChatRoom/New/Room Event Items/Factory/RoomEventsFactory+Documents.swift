import SwiftUI

extension RoomEventsFactory {
    static func makeDocumentItem(
        event: RoomEvent,
        nextMessagePadding: CGFloat,
        oldEvents: [RoomEvent],
        oldViews: [any ViewGeneratable],
        name: String?,
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
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState, messageType: event.eventType)
        )
        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let reactions: [ReactionNewEvent] = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        var viewModel: ReactionsNewViewModel
        if oldEvent?.reactions == event.reactions {
            viewModel = ReactionsNewViewModel(id: event.id, width: calculateEventWidth(StaticRoomEventsSizes.document.size, reactions.count),
                                              views: reactions,
                                              backgroundColor: reactionColor)
        } else {
            viewModel = ReactionsNewViewModel(width: calculateEventWidth(StaticRoomEventsSizes.document.size, reactions.count),
                                              views: reactions,
                                              backgroundColor: reactionColor)
        }
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
            isFromCurrentUser: event.isFromCurrentUser,
            fillColor: event.isFromCurrentUser ? .bubbles : .white,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: docItem, onSwipe: {
                onSwipeReply(event)
            }, swipeEdge: event.isFromCurrentUser ? .trailing : .leading
        )

        if event.isFromCurrentUser {
            return EventContainer(
                id: event.id,
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer, nextMessagePadding: nextMessagePadding, onLongPress: {
                    onLongPressTap(event)
                }, onTap: {}
            )
        }

        return EventContainer(
            id: event.id,
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            nextMessagePadding: nextMessagePadding, onLongPress: {
                onLongPressTap(event)
            }, onTap: {}
        )
    }
}
