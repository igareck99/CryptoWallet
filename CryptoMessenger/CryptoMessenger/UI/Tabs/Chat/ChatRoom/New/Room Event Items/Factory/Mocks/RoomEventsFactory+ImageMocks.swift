import Foundation

extension RoomEventsFactory {
    static func makeImageItem1() -> any ViewGeneratable {
        let eventData = EventData(
            date: "10:45",
            dateColor: .white,
            backColor: .osloGrayApprox,
            readData: ReadData(readImageName: R.image.chat.readCheck.name)
        )
        let reactionItems = [ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure)]
        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)

        let transactionItem = ImageEvent(
            placeholder: ShimmerModel(),
            eventData: eventData
        ) {
            debugPrint("onTap ImageEvent")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .diamond,
            cornerRadius: .right,
            content: transactionItem,
            bottomContent: reactionsGrid
        )

        return EventContainer(
            leadingContent: PaddingModel(),
            centralContent: bubbleContainer,
            bottomContent: ZeroViewModel()
        )
    }
}
