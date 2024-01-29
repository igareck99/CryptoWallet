import SwiftUI

extension RoomEventsFactory {

    static func makeAudioItem(event: RoomEvent,
                              nextMessagePadding: CGFloat,
                              oldEvents: [RoomEvent],
                              oldViews: [any ViewGeneratable],
                              url: URL?,
                              onLongPressTap: @escaping (RoomEvent) -> Void,
                              onReactionTap: @escaping (ReactionNewEvent) -> Void,
                              onSwipeReply: @escaping (RoomEvent) -> Void) -> (any ViewGeneratable)? {
        guard let url = url else { return ZeroViewModel() }
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
            dateColor: .osloGrayApprox,
            backColor: .clear,
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState, messageType: event.eventType)
        )
        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let reactions = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        var viewModel: any ViewGeneratable
        if !reactions.isEmpty {
            viewModel = ReactionsNewViewModel(width: calculateEventWidth(StaticRoomEventsSizes.image.size, reactions.count),
                                                  views: reactions,
                                                  backgroundColor: reactionColor)
        } else {
            viewModel = ZeroViewModel()
        }
        let audioItem = AudioEventItem(shortDate: event.shortDate,
                                       messageId: event.eventId,
                                       isCurrentUser: event.isFromCurrentUser,
                                       isFromCurrentUser: event.isFromCurrentUser,
                                       audioDuration: event.audioDuration,
                                       url: url,
                                       reactions: viewModel,
                                       eventData: eventData)
        let bubbleContainer = BubbleContainer(
            offset: 8.0,
            horizontalOffset: 12.0,
            isFromCurrentUser: event.isFromCurrentUser,
            fillColor: event.isFromCurrentUser ? .bubbles : .white,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: audioItem, onSwipe: {
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
            trailingContent: PaddingModel(), nextMessagePadding: nextMessagePadding, onLongPress: {
                onLongPressTap(event)
            }, onTap: {}
        )
    }
}


func calculateEventWidth(_ size: CGFloat, _ reactions: Int = 0) -> CGFloat {
    return size - 8
}
