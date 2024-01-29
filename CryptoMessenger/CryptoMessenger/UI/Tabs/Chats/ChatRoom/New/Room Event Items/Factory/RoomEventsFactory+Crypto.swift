import Foundation
import SwiftUI

extension RoomEventsFactory {
    static func makeTransactionItem(
        delegate: ChatEventsDelegate,
        event: RoomEvent,
        nextMessagePadding: CGFloat,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onSwipeReply: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void
    ) -> any ViewGeneratable {
        
        let readData = readData(
            isFromCurrentUser: event.isFromCurrentUser,
            eventSendType: event.sentState,
            messageType: event.eventType
        )

        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            readData: self.readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState, messageType: event.eventType)
        )
        let reactionColor: Color = event.isFromCurrentUser ? .diamond : .aliceBlue
        let reactions = prepareReaction(
            event,
            onReactionTap: { reaction in
                onReactionTap(reaction)
            }
        )
        let reactionsModel: any ViewGeneratable
        if !reactions.isEmpty {
            reactionsModel = ReactionsNewViewModel(
                width: calculateEventWidth(StaticRoomEventsSizes.image.size, reactions.count),
                views: reactions,
                backgroundColor: reactionColor
            )
        } else {
            reactionsModel = ZeroViewModel()
        }

        let amount: String = event.content[.amount] as? String ?? ""
        let currency: String = event.content[.currency] as? String ?? ""
        let dateStr: String = event.formattedDate

        let transactionItem = TransactionEvent(
            title: "Транзакция отправлена",
            subtitle: dateStr,
            amount: amount + " " + currency,
            amountBackColor: event.isFromCurrentUser ? .diamond : .antiFlashWhite,
            reactionsGrid: reactionsModel,
            eventData: eventData
        ) {
            debugPrint("onTap TransactionEvent")
            delegate.didTapCryptoSend(event: event)
        }

        let bubbleContainer = BubbleContainer(
            isFromCurrentUser: event.isFromCurrentUser,
            fillColor: event.isFromCurrentUser ? .bubbles : .white,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: transactionItem,
            onSwipe: { onSwipeReply(event) },
            swipeEdge: event.isFromCurrentUser ? .trailing : .leading
        )

        if event.isFromCurrentUser {
            return EventContainer(
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer,
                nextMessagePadding: nextMessagePadding, onLongPress: { onLongPressTap(event) },
                onTap: {}
            )
        }

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            nextMessagePadding: nextMessagePadding, onLongPress: { onLongPressTap(event) },
            onTap: {}
        )
    }
}
