import Foundation

extension RoomEventsFactory {
    static func makeContactItem(
        event: RoomEvent,
        name: String?,
        phone: String?,
        url: URL?,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void
    ) -> any ViewGeneratable {
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            readData: ReadData(readImageName: R.image.chat.readCheck.name)
        )
        let reactions = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        let viewModel = ReactionsNewViewModel(width: calculateWidth("", reactions.count),
                                              views: reactions,
                                              backgroundColor: .brilliantAzure)
        let userAvatar = UserAvatar(
            size: CGSize(width: 48.0, height: 48.0),
            placeholder: AvatarLetter(letter: "TK", backColor: .dodgerTransBlue)
        )

        let contactItem = ContactItem(
            title: name ?? "",
            subtitle: phone ?? "",
            reactionsGrid: viewModel,
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
