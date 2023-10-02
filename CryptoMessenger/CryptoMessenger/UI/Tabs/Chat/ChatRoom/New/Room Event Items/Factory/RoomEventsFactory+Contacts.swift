import Foundation

extension RoomEventsFactory {
    static func makeContactItem(
        event: RoomEvent,
        name: String?,
        phone: String?,
        url: URL?,
        delegate: ChatEventsDelegate,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void
    ) -> any ViewGeneratable {

        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState)
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
            let contactInfo = ChatContactInfo(
                name: name ?? "",
                phone: phone,
                url: url
            )
            delegate.onContactEventTap(contactInfo: contactInfo)
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
