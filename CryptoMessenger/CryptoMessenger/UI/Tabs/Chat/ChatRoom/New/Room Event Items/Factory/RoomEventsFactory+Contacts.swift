import Foundation

extension RoomEventsFactory {
    static func makeContactItem(
        event: RoomEvent,
        name: String?,
        phone: String?,
        url: URL?
    ) -> any ViewGeneratable {
        let eventData = EventData(
            date: event.shortDate,
            readData: ReadData(readImageName: R.image.chat.readCheck.name)
        )
        let reactionItems = [ReactionTextsItem(texts: [ReactionTextItem(text: "😎")], backgroundColor: .brilliantAzure)]
        let reactionsGrid = ReactionsGridModel(reactionItems: reactionItems)
        let userAvatar = UserAvatar(
            size: CGSize(width: 48.0, height: 48.0),
            placeholder: AvatarLetter(letter: "TK", backColor: .dodgerTransBlue)
        )

        let contactItem = ContactItem(
            title: name ?? "",
            subtitle: phone ?? "",
            reactionsGrid: ZeroViewModel(),
            eventData: eventData,
            avatar: userAvatar
        ) {
            debugPrint("onTap ContactItem")
        }

        let bubbleContainer = BubbleContainer(
            fillColor: .water,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: contactItem
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