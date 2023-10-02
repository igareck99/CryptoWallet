import SwiftUI

extension RoomEventsFactory {
    static func makeMapItem(
        event: RoomEvent,
        lat: Double,
        lon: Double,
        delegate: ChatEventsDelegate,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void,
        onNotSentTap: @escaping (RoomEvent) -> Void
    ) -> any ViewGeneratable {
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            dateColor: .white,
            backColor: .osloGrayApprox,
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState)
        )
        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let reactions = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        let viewModel = ReactionsNewViewModel(width: calculateEventWidth(StaticRoomEventsSizes.map.size,  reactions.count),
                                              views: reactions,
                                              backgroundColor: reactionColor)

        let place = Place(name: "Name", latitude: lat, longitude: lon)
        let mapEventItem = MapEvent(
            place: Place(name: "Name", latitude: lat, longitude: lon),
            eventData: eventData
        ) {
            debugPrint("onTap MapEvent")
            delegate.onMapEventTap(place: place)
        }

        let bubbleContainer = BubbleContainer(
            offset: .zero,
            fillColor: .diamond,
            cornerRadius: event.isFromCurrentUser ? .right : .left,
            content: mapEventItem
        )
        
        if event.isFromCurrentUser {
            if event.sentState == .failToSend {
                let notSentModel = NotSentModel {
                    onNotSentTap(event)
                }
                return EventContainer(
                    leadingContent: PaddingModel(),
                    centralContent: bubbleContainer,
                    trailingContent: notSentModel,
                    bottomContent: viewModel, onLongPress: {
                        onLongPressTap(event)
                    }
                )
            }
            return EventContainer(
                leadingContent: PaddingModel(),
                centralContent: bubbleContainer,
                bottomContent: viewModel, onLongPress: {
                    onLongPressTap(event)
                }
            )
        }

        return EventContainer(
            centralContent: bubbleContainer,
            trailingContent: PaddingModel(),
            bottomContent: viewModel, onLongPress: {
                onLongPressTap(event)
            }
        )
    }
}
