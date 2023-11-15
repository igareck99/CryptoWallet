import SwiftUI

extension RoomEventsFactory {

    static func makeAudioItem(event: RoomEvent, url: URL?,
                              onLongPressTap: @escaping (RoomEvent) -> Void,
                              onReactionTap: @escaping (ReactionNewEvent) -> Void,
                              onSwipeReply: @escaping (RoomEvent) -> Void) -> any ViewGeneratable {
        guard let url = url else { return ZeroViewModel() }
        
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
            fillColor: .water,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: audioItem, onSwipe: {
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


func calculateEventWidth(_ size: CGFloat, _ reactions: Int = 0) -> CGFloat {
    return size - 8
}
