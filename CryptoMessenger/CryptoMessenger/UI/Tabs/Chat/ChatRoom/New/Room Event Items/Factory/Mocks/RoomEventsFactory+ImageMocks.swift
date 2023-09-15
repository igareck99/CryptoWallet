import Foundation

extension RoomEventsFactory {
//    static func makeImageItem1() -> any ViewGeneratable {
//        let eventData = EventData(
//            date: "10:45",
//            dateColor: .white,
//            backColor: .osloGrayApprox,
//            readData: ReadData(readImageName: R.image.chat.readCheck.name)
//        )
//        let reactionItems = [
//            ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure),
//            ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure),
//            ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure)
//        ]
//        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
//        let loadInfo = LoadInfo(
//            url: .mock,
//            textColor: .white,
//            backColor: .osloGrayApprox
//        )
//        let transactionItem = ImageEvent(
//            placeholder: ShimmerModel(),
//            eventData: eventData,
//            loadData: loadInfo
//        ) {
//            debugPrint("onTap ImageEvent")
//        }
//
//        let bubbleContainer = BubbleContainer(
//            fillColor: .diamond,
//            cornerRadius: .right,
//            content: transactionItem,
//            bottomContent: reactionsGrid
//        )
//
//        return EventContainer(
//            leadingContent: PaddingModel(),
//            centralContent: bubbleContainer,
//            bottomContent: ZeroViewModel()
//        )
//    }

    static func makeImageItem2() -> any ViewGeneratable {
        let eventData = EventData(
            date: "13:45",
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
        let imageEventItem = ImageEvent(
            placeholder: ShimmerModel(),
            eventData: eventData,
            loadData: loadInfo
        ) {
            debugPrint("onTap ImageEvent")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .diamond,
            cornerRadius: .right,
            content: imageEventItem,
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
