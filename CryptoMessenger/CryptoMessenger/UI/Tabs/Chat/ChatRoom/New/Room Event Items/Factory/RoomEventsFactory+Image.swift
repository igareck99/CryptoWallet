import SwiftUI

extension RoomEventsFactory {
    static func makeImageItem(
        event: RoomEvent,
        url: URL?
    ) -> any ViewGeneratable {
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            dateColor: .white,
            backColor: .osloGrayApprox,
            readData: ReadData(readImageName: R.image.chat.readCheck.name)
        )
        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let items: [ReactionNewEvent] = prepareReaction(event)
        let viewModel = ReactionsNewViewModel(width: calculateEventWidth(StaticRoomEventsSizes.image.size, items.count),
                                              views: items,
                                              backgroundColor: reactionColor)
        
        let loadInfo = LoadInfo(
            url: .mock,
            textColor: .white,
            backColor: .osloGrayApprox
        )
        let transactionItem = ImageEvent(
            placeholder: ShimmerModel(),
            eventData: eventData,
            loadData: loadInfo
        ) {
            debugPrint("onTap ImageEvent")
        }
        
        let bubbleContainer = BubbleContainer(
            fillColor: .diamond,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: transactionItem
        )
        
        if event.isFromCurrentUser {
            return EventContainer(
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer,
                bottomContent: viewModel
            )
        }

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            bottomContent: viewModel
        )
    }
}
