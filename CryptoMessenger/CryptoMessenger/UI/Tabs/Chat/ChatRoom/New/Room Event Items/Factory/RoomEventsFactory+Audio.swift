import SwiftUI

extension RoomEventsFactory {

    static func makeAudioItem(event: RoomEvent, url: URL?,
                              onLongPressTap: @escaping (RoomEvent) -> Void,
                              onReactionTap: @escaping (ReactionNewEvent) -> Void) -> any ViewGeneratable {
        guard let url = url else { return ZeroViewModel() }
        
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            dateColor: .white,
            backColor: .osloGrayApprox,
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState)
        )
        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let reactions = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        let viewModel = ReactionsNewViewModel(width: calculateEventWidth(StaticRoomEventsSizes.audio.size,  reactions.count),
                                              views: reactions,
                                              backgroundColor: reactionColor)
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
            content: audioItem
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
