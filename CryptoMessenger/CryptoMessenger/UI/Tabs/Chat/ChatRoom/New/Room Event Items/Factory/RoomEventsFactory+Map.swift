import SwiftUI

extension RoomEventsFactory {
    static func makeMapItem(
        event: RoomEvent,
        lat: Double,
        lon: Double,
        delegate: ChatEventsDelegate,
        onLongPressTap: @escaping (RoomEvent) -> Void,
        onReactionTap: @escaping (ReactionNewEvent) -> Void,
        onNotSentTap: @escaping (RoomEvent) -> Void,
        onSwipeReply: @escaping (RoomEvent) -> Void
    ) -> any ViewGeneratable {
        var color: Color = .clear
        var textColor: Color = .chineseShadow
        switch event.eventType {
        case .video(_), .image(_), .location(_):
            color = .osloGrayApprox
            textColor = .white
        default:
            break
        }
        let eventData = EventData(
            date: event.shortDate,
            isFromCurrentUser: event.isFromCurrentUser,
            dateColor: textColor,
            backColor: color,
            readData: readData(isFromCurrentUser: event.isFromCurrentUser, eventSendType: event.sentState, messageType: event.eventType)
        )
        let reactionColor: Color = event.isFromCurrentUser ? .diamond: .aliceBlue
        let reactions = prepareReaction(event, onReactionTap: { reaction in
            onReactionTap(reaction)
        })
        var viewModel: any ViewGeneratable
        if !reactions.isEmpty {
            viewModel = ReactionsNewViewModel(width: calculateEventWidth(StaticRoomEventsSizes.image.size, reactions.count),
                                                  views: reactions,
                                                  backgroundColor: reactionColor)
        } else {
            viewModel = ZeroViewModel()
        }

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
            content: mapEventItem, onSwipe: {
                onSwipeReply(event)
            }, swipeEdge: event.isFromCurrentUser ? .trailing : .leading
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
