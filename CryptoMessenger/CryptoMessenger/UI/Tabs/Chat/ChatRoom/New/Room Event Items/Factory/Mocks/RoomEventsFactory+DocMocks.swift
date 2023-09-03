import Foundation

//extension RoomEventsFactory {
//    static func makeDocItem1() -> any ViewGeneratable {
//        let eventData = EventData(
//            date: "11:45",
//            readData: ReadData(readImageName: R.image.chat.readCheckWhite.name)
//        )
//        let reactionItems = [ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure)]
//        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
//        let docItem = DocumentItem(
//            imageName: "paperclip.circle.fill",
//            title: "Экран для Aura.docx",
//            subtitle: "2.8MB",
//            url: .mock,
//            reactionsGrid: reactionsGrid,
//            eventData: eventData
//        ) {
//            debugPrint("onTap DocumentItem")
//        }
//
//        let bubbleContainer = BubbleContainer(
//            fillColor: .water,
//            cornerRadius: .left,
//            content: docItem
//        )
//
//        return EventContainer(
//            centralContent: bubbleContainer,
//            trailingContent: PaddingModel()
//        )
//    }
//
//    static func makeDocItem2() -> any ViewGeneratable {
//        let eventData = EventData(
//            date: "11:45",
//            readData: ReadData(readImageName: R.image.chat.readCheckWhite.name)
//        )
//        let reactionItems = [ReactionTextsItem(texts: [ReactionTextItem(text: "👍")], backgroundColor: .brilliantAzure)]
//        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
//        let docItem = DocumentItem(
//            imageName: "paperclip.circle.fill",
//            title: "Экран для Aura.docx",
//            subtitle: "2.8MB",
//            url: URL(string: "https://matrix.aura.ms/")!,
//            reactionsGrid: reactionsGrid,
//            eventData: eventData
//        ) {
//            debugPrint("onTap DocumentItem")
//        }
//
//        let bubbleContainer = BubbleContainer(
//            fillColor: .water,
//            cornerRadius: .right,
//            content: docItem
//        )
//
//        let notSentModel = NotSentModel(
//            imageName: "exclamationmark.circle.fill",
//            imageColor: .spanishCrimson
//        ) {
//            debugPrint("NotSentModel")
//        }
//
//        return EventContainer(
//            leadingContent: PaddingModel(),
//            centralContent: bubbleContainer,
//            trailingContent: notSentModel
//        )
//    }
//
//    static func makeDocItem3() -> any ViewGeneratable {
//        let eventData = EventData(
//            date: "11:45",
//            readData: ReadData(readImageName: R.image.chat.readCheckWhite.name)
//        )
//        let docItem = DocumentItem(
//            imageName: "paperclip.circle.fill",
//            title: "Экран для Aura.docx",
//            subtitle: "2.8MB",
//            url: URL(string: "https://matrix.aura.ms/")!,
//            reactionsGrid: ZeroViewModel(),
//            eventData: eventData
//        ) {
//            debugPrint("onTap DocumentItem")
//        }
//
//        let bubbleContainer = BubbleContainer(
//            fillColor: .water,
//            cornerRadius: .right,
//            content: docItem
//        )
//
//        let notSentModel = NotSentModel {
//            debugPrint("NotSentModel")
//        }
//
//        return EventContainer(
//            leadingContent: PaddingModel(),
//            centralContent: bubbleContainer,
//            trailingContent: notSentModel
//        )
//    }
//}
