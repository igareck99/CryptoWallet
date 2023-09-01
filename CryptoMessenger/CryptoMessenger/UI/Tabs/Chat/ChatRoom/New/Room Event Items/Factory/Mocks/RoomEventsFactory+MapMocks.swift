import Foundation

extension RoomEventsFactory {
    static func makeMapItem1() -> any ViewGeneratable {
        let eventData = EventData(
            date: "17:45",
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

        let mapEventItem = MapEvent(
            place: .Moscow,
            eventData: eventData
        ) {
            debugPrint("onTap MapEvent")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .diamond,
            cornerRadius: .right,
            content: mapEventItem,
            bottomContent: reactionsGrid
        )

        // 38 это высота view с реакциями
        let notSentModel = NotSentModel(bottomOffset: ReactionsSizes.minHeight) {
            debugPrint("onTap NotSentModel")
        }

        return EventContainer(
            leadingContent: PaddingModel(),
            centralContent: bubbleContainer,
            trailingContent: notSentModel
        )
    }
}
