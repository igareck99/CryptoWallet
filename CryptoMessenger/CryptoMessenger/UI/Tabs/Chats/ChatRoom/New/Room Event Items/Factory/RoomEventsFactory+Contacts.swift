import SwiftUI

extension RoomEventsFactory {
    static func makeContactItem(
        event: RoomEvent,
        nextMessagePadding: CGFloat,
        oldEvents: [RoomEvent],
        oldViews: [any ViewGeneratable],
        name: String?,
        phone: String?,
        url: URL?,
        delegate: ChatEventsDelegate,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void,
        onSwipeReply: @escaping (RoomEvent) -> Void
    ) -> (any ViewGeneratable)? {
        let oldEvent = oldEvents.first(where: { $0.eventId == event.eventId })
        if event.sentState == .sent {
            if oldEvent == event {
                guard let view = oldViews.first(where: { $0.id == event.id }) else { return nil }
                return view
            }
        }
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState, messageType: event.eventType)
        )
        let reactionColor: Color = event.isFromCurrentUser ? .diamond : .aliceBlue
        let reactions: [ReactionNewEvent] = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        var viewModel: ReactionsNewViewModel
        if oldEvent?.reactions == event.reactions {
            viewModel = ReactionsNewViewModel(id: event.id, width: calculateEventWidth(StaticRoomEventsSizes.contact.size, reactions.count),
                                              views: reactions,
                                              backgroundColor: reactionColor)
        } else {
            viewModel = ReactionsNewViewModel(width: calculateEventWidth(StaticRoomEventsSizes.contact.size, reactions.count),
                                              
                                              views: reactions,
                                              backgroundColor: reactionColor)
        }
        let nameWithoutSpaces = Array(name?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() ?? "")
        var userAvatarLetters = ""
        if let firstLetter = nameWithoutSpaces[safe: 0] {
            userAvatarLetters += firstLetter.description
        }
        if let secondLetter = nameWithoutSpaces[safe: 1] {
            userAvatarLetters += secondLetter.description
        }
        let userAvatar = UserAvatar(
            size: CGSize(width: 48.0, height: 48.0),
            placeholder: AvatarLetter(letter: userAvatarLetters, backColor: .diamond)
        )
        let contactItem = ContactItem(
            id: event.id,
            title: name ?? "",
            subtitle: phone ?? "",
            mxId: event.contactMxId,
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
            offset: 8.0,
            horizontalOffset: 12.0,
            isFromCurrentUser: event.isFromCurrentUser,
            fillColor: event.isFromCurrentUser ? .bubbles : .white,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: contactItem, onSwipe: {
                onSwipeReply(event)
            }, swipeEdge: event.isFromCurrentUser ? .trailing : .leading
        )

        if event.isFromCurrentUser {
            return EventContainer(
                id: event.id,
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer, nextMessagePadding: nextMessagePadding, onLongPress: {
                    onLongPressTap(event)
                }, onTap: {}
            )
        }

        return EventContainer(
            id: event.id,
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(), nextMessagePadding: nextMessagePadding, onLongPress: {
                onLongPressTap(event)
            }, onTap: {}
        )
    }
}
