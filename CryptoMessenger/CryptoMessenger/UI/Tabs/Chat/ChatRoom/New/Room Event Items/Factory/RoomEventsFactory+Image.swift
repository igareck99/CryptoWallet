import Foundation

extension RoomEventsFactory {
    static func makeImageItem(
        event: RoomEvent,
        url: URL?
    ) -> any ViewGeneratable {
        let eventData = EventData(
            date: event.shortDate,
            dateColor: .white,
            backColor: .osloGrayApprox,
            readData: ReadData(readImageName: R.image.chat.readCheck.name)
        )
        let reactionItems = [
            ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure),
            ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure),
            ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure)
        ]
        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
        
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
                centralContent: bubbleContainer
            )
        }
        
        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel()
        )
    }
}
