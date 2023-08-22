import Foundation

extension RoomEventsFactory {
    static func makeContactItem1() -> any ViewGeneratable {
        let eventData = EventData(
            date: "11:45",
            readData: ReadData(readImageName: R.image.chat.readCheck.name)
        )
        let reactionItems = [ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure)]
        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
        let userAvatar = UserAvatar(
            size: CGSize(width: 48.0, height: 48.0),
            placeholder: AvatarLetter(letter: "TK", backColor: .dodgerTransBlue)
        )
        let contactItem = ContactItem(
            title: "Виолетта Силенина",
            subtitle: "+7(925)813-31-62",
            reactionsGrid: reactionsGrid,
            eventData: eventData,
            avatar: userAvatar
        ) {
            debugPrint("onTap ContactItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .left,
            content: contactItem
        )

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel()
        )
    }

    static func makeContactItem2() -> any ViewGeneratable {
        let eventData = EventData(
            date: "11:45",
            readData: ReadData(readImageName: R.image.chat.readCheck.name)
        )
        let reactionItems = [ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure)]
        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
        let userAvatar = UserAvatar(
            size: CGSize(width: 48.0, height: 48.0),
            placeholder: AvatarLetter(letter: "FK", backColor: .dodgerTransBlue)
        )
        let contactItem = ContactItem(
            title: "Виолетта Силенина",
            subtitle: "+7(627)823-34-62",
            reactionsGrid: reactionsGrid,
            eventData: eventData,
            avatar: userAvatar
        ) {
            debugPrint("onTap ContactItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .right,
            content: contactItem
        )

        return EventContainer(
            leadingContent: PaddingModel(),
            centralContent: bubbleContainer
        )
    }

    static func makeContactItem3() -> any ViewGeneratable {
        let eventData = EventData(
            date: "11:45",
            readData: ReadData(readImageName: R.image.chat.readCheck.name)
        )

        let userAvatar = UserAvatar(
            size: CGSize(width: 48.0, height: 48.0),
            placeholder: AvatarLetter(letter: "PK", backColor: .dodgerTransBlue)
        )
        let contactItem = ContactItem(
            title: "Виолетта Силенина",
            subtitle: "+7(627)823-34-62",
            reactionsGrid: ZeroViewModel(),
            eventData: eventData,
            avatar: userAvatar
        ) {
            debugPrint("onTap ContactItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: .right,
            content: contactItem
        )

        let notSentModel = NotSentModel {
            debugPrint("onTap NotSentModel")
        }

        return EventContainer(
            leadingContent: PaddingModel(),
            centralContent: bubbleContainer,
            trailingContent: notSentModel
        )
    }
}
